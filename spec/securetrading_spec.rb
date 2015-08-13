require 'spec_helper'

describe SecureTrading do
  after { described_class.send('config=', nil) }

  it 'has a version number' do
    expect(SecureTrading::VERSION).not_to be(nil)
  end

  describe '#config' do
    context 'when not set' do
      it 'returns new configuration', type: :no_config do
        new_config = SecureTrading::Configuration.new
        expect(SecureTrading::Configuration).to receive(:new) { new_config }
        expect(subject.config).to eq(new_config)
      end
    end

    context 'when it is set' do
      it 'contains set value' do
        expect(subject.config.user).to eq('u')
      end
    end
  end

  describe '#configure' do
    it 'sets config', type: :no_config do
      expect do
        described_class.configure { |c| c.user = 'a' }
      end.to change { described_class.config.user }.from(nil).to('a')
    end
  end
end
