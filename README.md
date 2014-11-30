# Capistrano::OneTimeKey

Capistrano::OneTimeKey creates per-deploy ssh keys. This may be useful in SSH environments that use alternative authentication mechanisms (e.g. kerberos) that have no (reliably maintained) net-ssh equivalents.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-one_time_key'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-one_time_key

## Usage

In your Capfile, require the gem:

    require 'capistrano/one_time_key'

And in your deploy stage, after you register servers and services, create the one time keys:

    server ENV['HOST'], user: ENV['USER'], roles: %w{app}
    Capistrano::OneTimeKey.generate_one_time_key!
    # Optional modification of ssh options.
    ssh_opts = fetch(:ssh_options)
    ssh_opts[:forward_agent] = true
    ssh_opts[:verbose] = false

## Contributing

1. Fork it ( http://github.com/cbeer/capistrano-one_time_key/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
