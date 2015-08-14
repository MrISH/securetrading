module Securetrading
  class SiteSecurity
    def self.hash(fields)
      Digest::SHA256.hexdigest(str_to_encode(fields))
    end

    def self.str_to_encode(fields)
      str = ''
      fields.reverse_merge!(authmethod: Securetrading.config.auth_method)
      %i(currencyiso3a mainamount sitereference settlestatus
         settleduedate authmethod paypaladdressoverride strequiredfields
         version stprofile ruleidentifier successfulurlredirect
         declinedurlredirect).each do |field|
        str << fields[field].to_s
      end
      str << Securetrading.config.site_security_password
    end
    private_class_method :str_to_encode
  end
end
