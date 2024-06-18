namespace :load do
  task :defaults do
    set :ssh_options, {
      keys: [Capistrano::OneTimeKey.temporary_ssh_private_key_path],
      forward_agent: false,
      auth_methods: %w(publickey password)
    }
  end
end

namespace :otk do
  task :generate do
    Capistrano::OneTimeKey.use_one_time_key!
  end
end

namespace :deploy do
  before :starting, :generate_otk do
    invoke 'otk:generate'
  end
end
