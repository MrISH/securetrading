module Securetrading
  class Record < BaseModel
    private

    def sub_classes
      %w(operation settlement billing merchant customer)
    end
  end
end
