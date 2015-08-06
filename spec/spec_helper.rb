if ENV['BUILDER'] == 'travis'
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
else
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'secure_trading'

RSpec.configure do |config|
  config.around(:each) do |test|
    set_config if test.metadata[:type] != :no_config
    test.run
    reset_config if test.metadata[:type] != :no_config
  end
end

def set_config(user = 'u', password = 'p', site_reference = 'sr')
  SecureTrading.configure do |c|
    c.user = user
    c.password = password
    c.site_reference = site_reference
  end
end

def reset_config
  SecureTrading.send('config=', nil)
end
