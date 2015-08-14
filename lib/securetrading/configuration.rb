module Securetrading
  class ConfigurationError < StandardError; end
  class Configuration
    attr_accessor :user, :password
    attr_writer :site_reference, :auth_method, :site_security_password

    def site_security_password
      return @site_security_password if @site_security_password.present?
      fail ConfigurationError, 'You are trying to use site security '\
        'but your password is empty. Please check gem configuration.'
    end

    def auth_method
      @auth_method ||= 'FINAL'.freeze
    end

    def site_reference
      return @site_reference if @site_reference.present?
      fail ConfigurationError, 'Site reference is required!'
    end

    def auth
      return @auth if @auth.present?
      if user.present? && password.present?
        @auth ||= Base64.encode64("#{user}:#{password}")
      else
        fail ConfigurationError, 'User and password or auth are required!'
      end
    end
  end
end
