require 'spec_helper'

describe SecureTrading::Connection do
  describe '#post_with' do
    before do
      SecureTrading.configure do |c|
        c.user = 'u'
        c.password = 'c'
      end
    end
    after { SecureTrading.send('config=', 'nil') }

    it 'calls post with params' do
      expect(described_class).to receive(:post)
        .with('/',
              body: '',
              headers: { 'Authorization' => "Basic #{Base64.encode64('u:c')}" }
             )
      described_class.new.post_with('')
    end
  end
end
