require 'spec_helper'

describe Securetrading::Connection do
  describe '#post_with' do
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
      described_class.new.post_with('')
    end
  end
end
