module SecureTrading
  class Configuration
    attr_accessor :user, :password, :sitereference
    attr_writer :auth

    def auth
      @auth ||= Base64.encode64 "#{user}:#{password}"
    end
  end
end
