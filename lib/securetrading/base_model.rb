module Securetrading
  class BaseModel
    attr_reader :attributes_hash

    def initialize(attrs_hash = {})
      @attributes_hash = attrs_hash.presence &&
                         attrs_hash.transform_keys! { |k| k.to_s.tr('__', '') }
    end

    def ox_xml
      ox = ox_from_values
      sub_classes.each do |sub_class_name|
        next unless attributes_hash.key?(sub_class_name)
        ox << send(sub_class_name).ox_xml
      end
      ox
    end

    private

    def ox_from_values
      XmlDoc
        .elements(xml_tag_name => @attributes_hash.except(*sub_classes))
        .first
    end

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
  end
end
