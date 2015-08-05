require 'spec_helper'

describe SecureTrading::Configuration do
  it { expect(subject).to respond_to :user }
  it { expect(subject).to respond_to :password }
  it { expect(subject).to respond_to :sitereference }
  it { expect(subject).to respond_to :auth }

  let(:config_attrs) { {} }
  let(:config) { described_class.new }

  before do
    config_attrs.each do |k, v|
      config.public_send("#{k}=", v)
    end
  end

  describe '#auth' do
    context 'when set by writer' do
      it 'returns its value' do
        config.auth = 'auth'
        expect(config.auth).to eq 'auth'
      end
    end

    context 'when not set' do
      let(:config_attrs) { { user: 'a', password: 'b' } }

      it 'returns Base64 encoded user:password string' do
        expect(config.auth).to eq Base64.encode64('a:b')
      end
    end
  end
end
