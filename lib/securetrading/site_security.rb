module Securetrading
  class SiteSecurity
    def self.hash(fields, config_options = nil)
      Digest::SHA256.hexdigest(str_to_encode(fields, config_options))
    end

    def self.str_to_encode(fields, config_options = nil)
      config = configuration(config_options)
      str = ''
      fields.reverse_merge!(authmethod: config.auth_method)
      %i(currencyiso3a mainamount sitereference settlestatus authmethod
         settleduedate paypaladdressoverride strequiredfields version
         stprofile ruleidentifier successfulurlredirect
         declinedurlredirect).each do |field|
        str << fields[field].to_s
      end
      str << config.site_security_password
    end

    def self.configuration(config_options)
      return Securetrading.config unless config_options.present?
      Configuration.new(config_options)
    end
    private_class_method :str_to_encode, :configuration
  end
end
