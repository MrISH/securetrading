module Securetrading
  class Amount < BaseModel
    def value
      attributes_hash['__content__']
    end
  end
end
