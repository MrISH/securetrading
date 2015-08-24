module Securetrading
  class Amount < BaseModel
    def value
      attributes_hash['__content__']
    end

    def ox_xml
      el = XmlDoc.new_element(xml_tag_name)
      el['currencycode'] = currencycode
      el << value.to_s
    end
  end
end
