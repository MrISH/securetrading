require 'securetrading/base_model'

module Securetrading
  class Customer < BaseModel; end
  class Dcc < BaseModel; end
  class Merchant < BaseModel; end
  class Name < BaseModel; end
  class Operation < BaseModel; end
  class Payment < BaseModel; end
  class ResponseError < BaseModel; end
  class Settlement < BaseModel; end
  class Security < BaseModel; end
end

require 'securetrading/amount'
require 'securetrading/billing'
require 'securetrading/record'
require 'securetrading/response'
