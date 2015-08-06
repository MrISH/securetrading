require 'secure_trading/version'
require 'ox'
require 'httparty'
require 'active_support'
require 'active_support/core_ext'
require 'secure_trading/configuration'

module SecureTrading
  def self.configure
    yield(config)
  end

  def self.config
    @config ||= Configuration.new
  end

  class << self
    attr_writer :config
  end
  private_class_method 'config='
end

require 'secure_trading/connection'
