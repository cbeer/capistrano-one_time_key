$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec/autorun'
require 'capistrano/one_time_key'

RSpec.configure do |config|

end