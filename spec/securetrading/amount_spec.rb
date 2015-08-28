require 'spec_helper'

describe Securetrading::Amount do
  it { should respond_to(:value) }
  it { should respond_to(:currency_code) }

  let(:amount) { described_class.new(content: 1, currencycode: 'EUR') }

  describe '#value' do
    it 'returns value from content attribute' do
      expect(amount.value).to eq(1)
    end
  end

  describe '#ox_xml' do
    it 'returns xml ox representation' do
      expect(Ox.dump(amount.ox_xml))
        .to eq("\n<amount currencycode=\"EUR\">1</amount>\n")
    end

    context 'when there is no currencycode specified' do
      let(:amount) { described_class.new(content: 1) }

      it 'returns xml ox representation without currency' do
        expect(Ox.dump(amount.ox_xml))
          .to eq("\n<amount>1</amount>\n")
      end
    end
  end
end
