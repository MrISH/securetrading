module Securetrading
  class XmlDoc
    def initialize(request_type, account_type)
      @account_type = account_type
      @request_type = request_type
    end

    def doc
      return @doc if @doc.present?
      @doc = Ox::Document.new(version: '1.0')
      root = new_element('requestblock')
      root[:version] = '3.67'
      root << alias_el << request_el
      @doc << root
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

    def alias_el
      self.class.elements(alias: Securetrading.config.user).first
    end

    def request_el
      el = new_element('request')
      el[:type] = @request_type
      el
    end
  end
end
