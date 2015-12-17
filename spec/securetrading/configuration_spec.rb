require 'spec_helper'

describe Securetrading::Configuration, type: :no_config do
  it { expect(subject).to respond_to :user }
  it { expect(subject).to respond_to :password }
  it { expect(subject).to respond_to :site_reference }
  it { expect(subject).to respond_to :auth }
  it { expect(subject).to respond_to :auth_method }
  it { expect(subject).to respond_to :site_security_password }

  let(:config_attrs) { {} }
  let(:config) { described_class.new }

  before do
    config_attrs.each do |k, v|
      config.public_send("#{k}=", v)
    end
  end

  describe '#site_security_password' do
    context 'when set in configuration process' do
      let(:config_attrs) { { site_security_password: '123' } }
      it 'returns configured value' do
        expect(config.site_security_password).to eq('123')
      end
    end

    context 'when not set' do
      it 'fails with ConfigurationError' do
        expect { config.site_security_password }
          .to raise_error(Securetrading::ConfigurationError)
      end
    end
  end

  describe '#auth_method' do
    context 'when set in configuration process' do
      let(:config_attrs) { { auth_method: 'PRE' } }

      it 'returns configured value' do
        expect(config.auth_method).to eq('PRE')
      end
    end

    context 'when not set' do
      it "returns 'FINAL' as default" do
        expect(config.auth_method).to eq('FINAL')
      end
    end
  end

  describe '#auth' do
    let(:config_attrs) { { user: 'a', password: 'b' } }

    it 'returns Base64 encoded user:password string' do
      expect(config.auth).to eq Base64.encode64('a:b')
    end

    context 'when there is no user config' do
      let(:config_attrs) { { password: 'b' } }

      it 'fails with ConfigurationError' do
        expect { config.auth }
          .to raise_error(Securetrading::ConfigurationError)
      end
    end

    context 'when there is no password config' do
      let(:config_attrs) { { user: 'b' } }

      it 'fails with ConnectionError' do
        expect { config.auth }
          .to raise_error(Securetrading::ConfigurationError)
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
          .to raise_error(Securetrading::ConfigurationError)
      end
    end
  end

  context 'when initialized with options hash' do
    let(:config_opts) do
      {
        user: 'a',
        password: 'b',
        site_security_password: '123',
        site_reference: 'a',
        auth_method: 'PRE'
      }
    end
    let(:config) { described_class.new(config_opts) }

    it 'sets configuration options properly' do
      expect(config.user).to eq('a')
      expect(config.password).to eq('b')
      expect(config.site_security_password).to eq('123')
      expect(config.site_reference).to eq('a')
      expect(config.auth_method).to eq('PRE')
      expect(config.auth).to eq(Base64.encode64('a:b'))
    end
  end
end
