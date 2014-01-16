require "capistrano/one_time_key/version"
require "tmpdir"
require "securerandom"

module Capistrano
  module OneTimeKey

    def self.tmpdir
      @dirname ||= Dir.mktmpdir
    end

    def self.temporary_ssh_private_key_path
      File.join(tmpdir, "capistrano_key")
    end

    def self.comment
      @comment ||= "capistrano-otk-#{SecureRandom.hex(6)}"
    end

    def self.generate_private_key!
      `ssh-keygen -f #{temporary_ssh_private_key_path} -N "" -C "#{comment}"`
      return temporary_ssh_private_key_path
    end
    
    def self.generate_one_time_key!
      
      path = generate_private_key!
      
      public_key = File.read("#{path}.pub")

      on roles(:all) do |host|
        Capistrano::OneTimeKey.add_key_to_host host, public_key
      end

      at_exit do
        # remove dirname locally
        FileUtils.remove_entry Capistrano::OneTimeKey.temporary_ssh_private_key_path
        on roles(:all) do |host|
          Capistrano::OneTimeKey.remove_key_from_host host, public_key
        end
      end 
    end

    def self.add_key_to_host capistrano_host, public_key
      execute_on_remote capistrano_host, "mkdir -p ~/.ssh && \
        chmod 700 ~/.ssh && \
        touch ~/.ssh/authorized_keys && \
        chmod 600 ~/.ssh/authorized_keys && \
        echo '#{public_key}' >> ~/.ssh/authorized_keys"
    end

    def self.remove_key_from_host capistrano_host, public_key
      execute_on_remote capistrano_host, "sed -i.bak -e '/#{comment}$/d' ~/.ssh/authorized_keys && rm ~/.ssh/authorized_keys.bak"
    end

    def self.execute_on_remote capistrano_host, command
      `echo "#{command}" | ssh #{capistrano_host.user}@#{capistrano_host.hostname}`
    end
  end
end


load File.expand_path("../one_time_key/tasks/one_time_key.rake", __FILE__)
