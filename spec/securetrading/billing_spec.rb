require 'spec_helper'

describe Securetrading::Billing do
  let(:billing) do
    described_class.new(amount: { one: 1 },
                        name: { one: 1 },
                        dcc: { one: 1 },
                        payment: { one: 1 })
  end

  describe '#sub_classes' do
    it 'defines list of objects to return' do
      expect(billing.amount).to be_a(Securetrading::Amount)
      expect(billing.name).to be_a(Securetrading::Name)
      expect(billing.dcc).to be_a(Securetrading::Dcc)
      expect(billing.payment).to be_a(Securetrading::Payment)
    end
  end
end
