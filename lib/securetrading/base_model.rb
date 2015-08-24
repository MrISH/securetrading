module Securetrading
  class BaseModel
    def initialize(attrs_hash = {})
      @attributes_hash = attrs_hash.presence && attrs_hash.stringify_keys
    end

    def ox_xml
      XmlDoc.elements(xml_tag_name => @attributes_hash).first
    end

    private

    def xml_tag_name
      self.class.name.demodulize.downcase
    end

    def method_missing(m, *args, &block)
      return super unless attributes_hash.key?(m.to_s)
      determine_value(m.to_s)
    end

    def determine_value(name)
      if name == 'error'
        Securetrading::ResponseError.new(attributes_hash[name])
      elsif name.in?(sub_classes)
        "Securetrading::#{name.capitalize}".constantize
          .public_send(:new, attributes_hash[name])
      else
        attributes_hash[name]
      end
    end

    def sub_classes
      []
    end

    attr_reader :attributes_hash
  end
end
