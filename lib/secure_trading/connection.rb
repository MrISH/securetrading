module SecureTrading
  class Connection
    include HTTParty
    base_uri 'https://webservices.securetrading.net/xml/'
    format :xml
    # headers after: http://www.securetrading.com/files/documentation/STPP-Web-Services-User-Guide.pdf
    headers(
      'Content-Type' => 'text/xml;charset=utf-8',
      'Accept-Encoding' => 'gzip',
      'Accept' => 'text/xml',
      'User-Agent' => 'SecureTrading Ruby gem; '\
                      "version: #{SecureTrading::VERSION}",
      'Connection' => 'close'
    )

    def self.post_with(xml, options = {})
      post('', options.merge(body: xml, headers: dynamic_headers))
    end

    def self.dynamic_headers
      { 'Authorization' => "Basic #{SecureTrading.config.auth}" }
    end
    private_class_method :dynamic_headers
  end
end
