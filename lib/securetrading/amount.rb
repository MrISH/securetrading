module Securetrading
  class Amount < BaseModel
    def currency_code
      attributes_hash['currencycode']
    end

    def value
      attributes_hash['content']
    end

    def ox_xml
      el = XmlDoc.new_element(xml_tag_name)
      el['currencycode'] = currency_code if currency_code.present?
      el << value.to_s
    end
  end
end
