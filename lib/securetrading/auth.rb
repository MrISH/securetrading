=begin
<<-XML
  <requestblock version="3.67">
    <alias>site12345</alias>
    <request type="AUTH">

      <operation>
        <sitereference>site12345</sitereference>
        <accounttypedescription>ECOM</accounttypedescription>
      </operation>

      <merchant>
        <orderreference>AUTH_VISA</orderreference>
      </merchant>

      <billing>
        <telephone type="M">0777777777</telephone>
        <county>Gwynedd</county>
        <street>Test Street</street>
        <postcode>TE45 6ST</postcode>
        <premise>789</premise>

        <payment type="VISA">
          <expirydate>10/2031</expirydate>
          <pan>4111110000000211</pan>
          <securitycode>123</securitycode>
        </payment>

        <town>Bangor</town>

        <name>
          <middle>joe</middle>
          <prefix>Dr</prefix>
          <last>bloggs</last>
          <suffix>Jr.</suffix>
          <first>fred</first>
        </name>

        <country>GB</country>
        <amount currencycode="GBP">100</amount>
        <email>fred.bloggs@example.com</email>
      </billing>

      <customer>
        <town>Bangor</town>
        <name>
          <middle>Mary</middle>
          <prefix>Miss</prefix>
          <last>Smith</last>
          <first>Joanne</first>
        </name>
        <ip>1.2.3.4</ip>
        <telephone type="H">1111111111</telephone>
        <street>Second Street</street>
        <postcode>CU888ST</postcode>
        <premise>111</premise>
      </customer>

    </request>
  </requestblock>
XML
=end

module Securetrading
  class Auth < Connection
    def initialize(amount, parent_transaction, opts = {}, config_opts = {})
      @options = opts
      @amount = amount
      @card = @options[:card]
      @parent_transaction = parent_transaction
      @account_type = @options[:account_type].presence || 'ECOM'
      @customer = @options[:customer]
      @settlement = @options[:settlement]
      @config_options = config_opts
    end

    def perform(options = {})
      perform_with(:post, to_xml, options)
    end

    private

    def billing
      return '' unless [@amount, @options[:currencycode]].all?(&:present?)
      Billing.new({
        premise:    @customer[:premise], # house number
        street:     @customer[:street],
        county:     @customer[:county],
        country:    @customer[:country], # ISO2A
        email:      @customer[:email],
        name:       name,
        payment:    payment,
        postcode:   @customer[:postcode], # ST validates for US (5 or 9 digit zip code), GB ('TN NTT', 'TNT NTT', 'TNN NTT', 'TTN NTT', 'TTNN NTT', 'TTNT NTT') and CA ('TNT NTN', 'TNTNTN')
        town:       @customer[:town],
        amount:     {
          content: @amount,
          currencycode: ( @options[:currencycode] || 'GBP' )
         },
        settlement: settlement,
      }).ox_xml
    end

    def customer
      Customer.new(
        telephone:    @customer[:telephone],
        email:        @customer[:email],
        forwardedip:  @customer[:forwardedip],
        ip:           @customer[:ip],
        premise:      @customer[:premesis],
        street:       @customer[:street],
        county:       @customer[:county],
        country:      @customer[:country],
        postcode:     @customer[:postcode],
        town:         @customer[:town],
        name:         name,
      ).ox_xml
    end

    def merchant
      return '' unless @options[:merchant].present?
      Merchant.new(@options[:merchant]).ox_xml
    end

    def name
      return '' unless [@customer[:prefix], @customer[:first], @customer[:middle], @customer[:last], @customer[:suffix]].any?(&:present?)
      {
        prefix:   @customer[:prefix],
        first:    @customer[:first],
        middle:   @customer[:middle],
        last:     @customer[:last],
        suffix:   @customer[:suffix],
      }
    end

    def operation
      Operation.new(
        sitereference: config.site_reference,
        accounttypedescription: @account_type,
        parenttransactionreference: @parent_transaction
      ).ox_xml
    end

    def ox_xml
      prepare_doc do
        req = doc.requestblock.request
        req << operation << merchant << billing << customer
      end
    end

    def payment
      return '' unless [@card[:pan], @card[:expirydate]].all?(&:present?)
      {
        pan:          @card[:pan], # card number
        expirydate:   @card[:expirydate], # MM/YYYY
        securitycode: @card[:securitycode], # CCV
      }
    end

    def request_type
      'AUTH'.freeze
    end

    def settlement
      return '' unless @options[:settlement].present?
      Settlement.new(
        settleduedate: @settlement[:settleduedate], # YYYY-MM- DD
        settlestatus: (@settlement[:settlestatus]),
      ).ox_xml
    end

  end
end
