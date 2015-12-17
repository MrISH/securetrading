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

  describe '.configuration' do
    let(:config_opts) { nil }
    let(:configuration) do
      described_class.send(:configuration, config_opts)
    end
    before do
      Securetrading.configure { |c| c.auth_method = 'u' }
    end
    after { Securetrading.send('config=', 'nil') }

    context 'when config_options are present' do
      let(:config_opts) { { auth_method: 'from_opts' } }

      it 'returns new Configuration initialized with config_options' do
        expect(configuration.auth_method).to eq('from_opts')
      end
    end

    context 'when config_options are not present' do
      it 'returns config set by configuration' do
        expect(configuration.auth_method).to eq('u')
      end
    end
  end
end
