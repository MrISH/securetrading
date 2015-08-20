module Securetrading
  class Connection
    include HTTParty
    base_uri 'https://webservices.securetrading.net/xml'

    # headers after: http://www.securetrading.com/files/documentation/STPP-Web-Services-User-Guide.pdf
    headers(
      'Content-Type' => 'text/xml;charset=utf-8',
      'Accept-Encoding' => 'gzip',
      'Accept' => 'text/xml',
      'User-Agent' => 'Securetrading Ruby gem; '\
                      "version: #{Securetrading::VERSION}",
      'Connection' => 'close'
    )

    def to_xml
      Ox.dump(ox_xml)
    end

    private

    def doc
      @doc ||= XmlDoc.new(request_type, @account_type).doc
    end

    def request_type
      fail NotImplementedError, 'Implement :request_type method in subclas!'
    end

    def ox_xml
      fail NotImplementedError, 'Implement :ox_xml method in subclas!'
    end

    def perform_with(method, xml, options = {})
      party = self.class.public_send(
        method, '/', options.merge(body: xml, headers: dynamic_headers)
      )
      Securetrading::Response.new(party)
    end

    def dynamic_headers
      { 'Authorization' => "Basic #{Securetrading.config.auth}" }
    end

    def prepare_doc
      return doc if xml_prepared?
      yield
      @xml_prepared = true
      doc
    end

    def xml_prepared?
      @xml_prepared
    end
  end
end
