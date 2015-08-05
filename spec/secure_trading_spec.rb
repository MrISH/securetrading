require 'spec_helper'

describe SecureTrading do
  after { described_class.send('config=', nil) }

  it 'has a version number' do
    expect(SecureTrading::VERSION).not_to be nil
  end

  describe '#config' do
    context 'when not set' do
      it 'returns new configuration' do
        new_config = SecureTrading::Configuration.new
        expect(SecureTrading::Configuration).to receive(:new) { new_config }
        expect(subject.config).to eq new_config
      end
    end

    context 'when it is set' do
      before do
        described_class.configure { |c| c.user = 'a' }
      end

      it 'contains set value' do
        expect(subject.config.user).to eq 'a'
      end
    end
  end

  describe '#configure' do
    it 'sets config' do
      expect do
        described_class.configure { |c| c.user = 'a' }
      end.to change { described_class.config.user }.from(nil).to('a')
    end
  end
end
