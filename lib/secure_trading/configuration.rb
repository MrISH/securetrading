module SecureTrading
  class Configuration
    class ConfigurationError < StandardError; end

    attr_accessor :user, :password
    attr_writer :site_reference

    def site_reference
      return @site_reference if @site_reference.present?
      fail ConfigurationError, 'Site reference is required!'
    end

    def auth
      return if @auth.present?
      if user.present? && password.present?
        @auth ||= Base64.encode64("#{user}:#{password}")
      else
        fail ConfigurationError, 'User and password or auth are required!'
      end
    end
  end
end
