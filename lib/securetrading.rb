require 'securetrading/version'
require 'ox'
require 'httparty'
require 'active_support'
require 'active_support/core_ext'
require 'securetrading/configuration'

module Securetrading
  class Error < StandardError; end

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

require 'securetrading/connection'
require 'securetrading/xml_doc'
require 'securetrading/refund'
require 'securetrading/transaction_query'
require 'securetrading/site_security'
require 'securetrading/models'
