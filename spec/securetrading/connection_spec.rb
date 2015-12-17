require 'spec_helper'

describe Securetrading::Connection do
  describe '#perform_with' do
    before do
      Securetrading.configure do |c|
        c.user = 'u'
        c.password = 'c'
      end
      expect(described_class).to receive(:post)
        .with('/',
              body: '',
              headers: { 'Authorization' => "Basic #{Base64.encode64('u:c')}" }
             )
        .and_return(1)
    end
    after { Securetrading.send('config=', 'nil') }

    it 'calls post with params' do
      described_class.new.send(:perform_with, :post, '')
    end

    it 'returns Securetrading::Request' do
      expect(described_class.new.send(:perform_with, :post, ''))
        .to be_a(Securetrading::Response)
    end
  end

  describe '#request_type' do
    it 'raises NotImplementedError' do
      expect do
        described_class.new.send(:request_type)
      end.to raise_exception(NotImplementedError)
    end
  end

  describe '#ox_xml' do
    it 'raises NotImplementedError' do
      expect do
        described_class.new.send(:ox_xml)
      end.to raise_exception(NotImplementedError)
    end
  end

  describe '#config' do
    let(:conn) { described_class.new }
    before do
      Securetrading.configure { |c| c.user = 'u' }
    end
    after { Securetrading.send('config=', 'nil') }

    context 'when config_options are set' do
      before do
        conn.instance_variable_set('@config_options', user: 'from_opts')
      end

      it 'returns new Configuration initialized with config_options' do
        expect(conn.send(:config).user).to eq('from_opts')
      end
    end

    context 'when config_options are not set' do
      it 'returns config set by configuration' do
        expect(conn.send(:config).user).to eq('u')
      end
    end
  end
end
