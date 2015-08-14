require 'spec_helper'

describe Securetrading::SiteSecurity do
  describe '.hash' do
    it 'returns SHA256 encoded hash build from hash of fields' do
      expect(described_class.hash(currencyiso3a: 'EUR'))
        .to eq(Digest::SHA256.hexdigest('EURFINALssp'))
    end
  end

  describe '.str_to_encode' do
    context 'when authmethod is not passed in fields argument' do
      it 'returns string including auth_method from config' do
        expect(described_class.send(:str_to_encode, {})).to eq('FINALssp')
      end
    end

    context 'when authmethod is in fields' do
      it 'returns string including that value' do
        expect(described_class.send(:str_to_encode, authmethod: 'A'))
          .to eq('Assp')
      end
    end
  end
end
