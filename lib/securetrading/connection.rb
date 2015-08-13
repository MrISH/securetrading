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

    def post_with(xml, options = {})
      self.class.post('/', options.merge(body: xml, headers: dynamic_headers))
    end

    private

    def dynamic_headers
      { 'Authorization' => "Basic #{Securetrading.config.auth}" }
    end
  end
end
