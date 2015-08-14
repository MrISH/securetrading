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
require 'securetrading'

RSpec.configure do |config|
  config.around(:each) do |test|
    preset_config if test.metadata[:type] != :no_config
    test.run
    reset_config if test.metadata[:type] != :no_config
  end
end

def preset_config(options = {})
  Securetrading.configure do |c|
    c.user = options[:user] || 'u'
    c.password = options[:password] || 'p'
    c.site_reference = options[:site_reference] || 'sr'
    c.auth_method = options[:auth_method]
    c.site_security_password = options[:site_reference] || 'ssp'
  end
end

def reset_config
  Securetrading.send('config=', nil)
end
