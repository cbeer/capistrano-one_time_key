namespace :load do
  task :defaults do   
    set :ssh_options, {
      keys: [Capistrano::OneTimeKey.temporary_ssh_private_key_path],
      forward_agent: false,
      auth_methods: %w(publickey password)
    }
  end
end