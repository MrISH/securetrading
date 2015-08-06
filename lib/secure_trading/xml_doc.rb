module SecureTrading
  class XmlDoc
    def initialize(request_type, account_type)
      @account_type = account_type
      doc.requestblock << alias_el
      doc.requestblock << request(request_type)
    end

    def doc
      return @doc if @doc.present?
      @doc = Ox::Document.new(version: '1.0')
      root = new_element('requestblock')
      root[:version] = '3.67'
      @doc << root
      @doc
    end

    def self.elements(hash)
      return unless hash.present?
      hash.map do |k, v|
        el = new_element(k.to_s)
        if v.is_a? Hash
          elements(v).each { |e| el << e }
        else
          el << v.to_s
        end
        el
      end
    end

    def self.new_element(name)
      Ox::Element.new(name)
    end

    private

    def new_element(name)
      self.class.new_element(name)
    end

    def operation
      self.class.elements(
        operation: {
          sitereference: SecureTrading.config.site_reference,
          accounttypedescription: @account_type
        }
      ).first
    end

    def alias_el
      self.class.elements(alias: SecureTrading.config.user).first
    end

    def request(type)
      el = new_element('request')
      el[:type] = type
      el << operation
      el
    end
  end
end
