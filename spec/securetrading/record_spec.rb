require 'spec_helper'

describe Securetrading::Record do
  let(:record) do
    described_class.new(operation: { one: '1' },
                        settlement: { one: '1' },
                        billing: { one: '1' },
                        merchant: { one: '1' },
                        customer: { one: '1' })
  end

  describe '#sub_classes' do
    it 'defines list of objects to return' do
      expect(record.operation).to be_a(Securetrading::Operation)
      expect(record.settlement).to be_a(Securetrading::Settlement)
      expect(record.billing).to be_a(Securetrading::Billing)
      expect(record.merchant).to be_a(Securetrading::Merchant)
      expect(record.customer).to be_a(Securetrading::Customer)
    end
  end
end
