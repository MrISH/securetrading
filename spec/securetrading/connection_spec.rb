require 'spec_helper'

describe Securetrading::Connection do
  describe '#perform_with' do
    before do
      Securetrading.configure do |c|
        c.user = 'u'
        c.password = 'c'
      end
    end
    after { Securetrading.send('config=', 'nil') }

    it 'calls post with params' do
      expect(described_class).to receive(:post)
        .with('/',
              body: '',
              headers: { 'Authorization' => "Basic #{Base64.encode64('u:c')}" }
             )
      described_class.new.send(:perform_with, :post, '')
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
end
