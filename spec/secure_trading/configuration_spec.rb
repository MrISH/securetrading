require 'spec_helper'

describe SecureTrading::Configuration, type: :no_config do
  it { expect(subject).to respond_to :user }
  it { expect(subject).to respond_to :password }
  it { expect(subject).to respond_to :site_reference }
  it { expect(subject).to respond_to :auth }

  let(:config_attrs) { {} }
  let(:config) { described_class.new }

  before do
    config_attrs.each do |k, v|
      config.public_send("#{k}=", v)
    end
  end

  describe '#auth' do
    let(:config_attrs) { { user: 'a', password: 'b' } }

    it 'returns Base64 encoded user:password string' do
      expect(config.auth).to eq Base64.encode64('a:b')
    end

    context 'when there is no user config' do
      let(:config_attrs) { { password: 'b' } }

      it 'fails with ConnectionError' do
        expect { config.auth }
          .to raise_error(SecureTrading::ConfigurationError)
      end
    end

    context 'when there is no password config' do
      let(:config_attrs) { { user: 'b' } }

      it 'fails with ConnectionError' do
        expect { config.auth }
          .to raise_error(SecureTrading::ConfigurationError)
      end
    end
  end

  describe '#site_reference' do
    context 'when set' do
      let(:config_attrs) { { site_reference: 'a' } }

      it 'returns site_reference value' do
        expect(config.site_reference).to eq('a')
      end
    end

    context 'when not set' do
      it 'fails with ConfigurationError' do
        expect { config.site_reference }
          .to raise_error(SecureTrading::ConfigurationError)
      end
    end
  end
end
