[![Code Climate](https://codeclimate.com/github/bitgaming/securetrading/badges/gpa.svg)](https://codeclimate.com/github/bitgaming/securetrading)
[![Test Coverage](https://codeclimate.com/github/bitgaming/securetrading/badges/coverage.svg)](https://codeclimate.com/github/bitgaming/securetrading/coverage)
[![Build Status](https://travis-ci.org/bitgaming/securetrading.svg)](https://travis-ci.org/bitgaming/securetrading)

# Securetrading

Ruby library for [securetrading](http://www.securetrading.com/) API integration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'securetrading'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install securetrading

## Usage

### Configuration

Set up configuration options in initializer like this:

```
Securetrading.configure do |c|
  c.user = 'user_site1234@securetrading.com'
  c.password = 'password'
  c.site_reference = 'site1234'
end
```

Alternatively you may pass configuration options directly to request.

```
> config = { user: 'user', passowrd: 'password', site_reference: 'ref' }
> ref = Securetrading::Refund.new(11, '1-9-1912893', { merchant: { orderreference: 'order2'}, account_type: 'CFT' }, config)
> ref.perform
```

### Supported Api requests

Currently supported methods:

#### AUTH

Parameters:
- amount - refunded amount in cents
- parent_transaction - original transaction reference you want to refund.
- options - Hash of options.
  - card -  Check XML specification for card xml tags.
  - customer -  Check XML specification for customer xml tags.
  - settlement -  Check XML specification for settlement xml tags.
  - merchant - Check XML specification for merchant xml tags.
  - account_type - default to ECOM. If you want to set different ```accounttypedescription``` xml tag you should set this option.
  - currencycode - default to GBP. If you want to set different ```currencycode``` xml tag you should set this option.

```ruby
> ref = Securetrading::Auth.new(1000, nil, { card: {expirydate: '10/2031', pan: '4111110000000211', securitycode: '123' }, merchant: { orderreference: 'order2' }, account_type: 'CFT', customer: { email: 'fred.bloggs@example.com', county: 'Gwynedd', street: 'Test Street', postcode: 'TE45 6ST', premise: '789', prefix: 'Dr', first: 'fred', middle: 'joe', last: 'bloggs', suffix: 'Jr.', country: 'GB', town: 'Bangor' }, currencycode: 'GBP' }, { user: st_login@email.com, password: 'st_login_password', site_reference: 'site12345' })
> ref.perform
```

Will send post request with xml:

```XML
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
          <middle>joe</middle>
          <prefix>Dr</prefix>
          <last>bloggs</last>
          <suffix>Jr.</suffix>
          <first>fred</first>
        </name>
        <street>Test Street</street>
        <postcode>TE45 6ST</postcode>
        <premise>789</premise>
      </customer>

    </request>
  </requestblock>
```

Will get a response:

```
{"version"=>"3.67",
 "requestreference"=>"A1-111aaaaa",
 "secrand"=>"AAA1aAAAa11",
 "record"=>
  {"type"=>"AUTH",
   "merchant"=>{"orderreference"=>"1", "tid"=>"11111111", "chargedescription"=>"Order 1", "merchantnumber"=>"00000000", "merchantcountryiso2a"=>"GB"},
   "transactionreference"=>"1-1-1111111",
   "timestamp"=>"2016-01-01 00:00:00",
   "acquirerresponsecode"=>"00",
   "operation"=>{"splitfinalnumber"=>"1", "accounttypedescription"=>"ECOM"},
   "settlement"=>{"settleduedate"=>"2016-01-01", "settlestatus"=>"0"},
   "billing"=>{"amount"=>{"currencycode"=>"GBP", "__content__"=>"1000"}, "payment"=>{"type"=>"VISA", "issuer"=>"SecureTrading Test Issuer1", "pan"=>"411111######0211", "issuercountry"=>"US"}, "dcc"=>{"enabled"=>"0"}},
   "authcode"=>"TEST01",
   "live"=>"0",
   "error"=>{"message"=>"Ok", "code"=>"0"},
   "security"=>{"postcode"=>"4", "securitycode"=>"2", "address"=>"4"}},
 "found"=>"1"}

```

#### REFUND

Parameters:
- amount - refunded amount in cents
- parent_transaction - original transaction reference you want to refund.
- options - Hash of options.
  - merchant - Check XML specification for merchant xml tags.
  - account_type - default to ECOM. If you want to set different ```accounttypedescription``` xml tag you should set this option.

```ruby
> ref = Securetrading::Refund.new(11, '1-9-1912893', { merchant: { orderreference: 'order2'}, account_type: 'CFT' })
> ref.perform
```

Will send post request with xml:

```XML
<requestblock version="3.67">
  <alias>user_site1234@securetrading.com</alias>
  <request type="REFUND">
    <operation>
      <sitereference>site1234</sitereference>
      <accounttypedescription>CFT</accounttypedescription>
      <parenttransactionreference>1-9-1912893</parenttransactionreference>
    </operation>
    <merchant>
      <orderreference>order2</orderreference>
    </merchant>
    <billing>
      <amount>11</amount>
    </billing>
  </request>
</requestblock>
```

#### TRANSACTIONQUERY

Parameters: 
- filters - list of filter xml subtags. You may find full list of filters in this doc: [http://www.securetrading.com/support/document/xml-reference-transaction-query/](http://www.securetrading.com/support/document/xml-reference-transaction-query/)

Example:

```ruby
> query = Securetrading::TransactionQuery.new(transactionreference: [ '5-9-1982481', '5-9-1980795'])
> query.perform
```
It will send post request with xml:

```XML
<requestblock version=\"3.67\">
  <alias>user_site1234@securetrading.com</alias>
  <request type=\"TRANSACTIONQUERY\">
    <filter>
      <transactionreference>5-9-1982481</transactionreference>
      <transactionreference>5-9-1980795</transactionreference>
    </filter>
  </request>
</requestblock>
```

#### SiteSecurity

Helper class for sitesecurity value calculation.
More details in [STPP-Payment-Pages-Setup-Guide-V2](http://www.securetrading.com/files/documentation/STPP-Payment-Pages-Setup-Guide-V2.pdf) chapter 6.

Methods:
 * hash(fields) - calculates SHA256 hash from fields. List of fields you can check in doc above.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bitgamelabs/securetrading. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

