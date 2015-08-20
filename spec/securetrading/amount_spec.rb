require 'spec_helper'

describe Securetrading::Amount do
  it { should respond_to(:value) }

  let(:amount) { described_class.new(__content__: 1) }

  describe '#value' do
    it 'returns value from __content__ attribute' do
      expect(amount.value).to eq(1)
    end
  end
end
