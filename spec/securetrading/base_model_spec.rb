require 'spec_helper'

describe Securetrading::BaseModel do
  let(:attributes) { { one: { two: 'three' } } }
  let(:model) { described_class.new(attributes) }

  describe '#method_missing' do
    context 'when attributes_hash contains key' do
      it 'returns value from attributes_hash' do
        expect(model.one).to eq(two: 'three')
      end

      context 'when key equals error' do
        let(:attributes) { { error: { code: 0 } } }
        it 'returns Securetrading::ResponseError' do
          expect(model.error).to be_a(Securetrading::ResponseError)
          expect(model.error.code).to eq(0)
        end
      end

      context 'when key is in sub_classes' do
        let(:attributes) { { billing: { one: 'two' } } }

        before do
          allow(model).to receive(:sub_classes) { %w(billing) }
        end

        it 'returns object of class from sub_classes' do
          expect(model.billing).to be_a(Securetrading::Billing)
          expect(model.billing.one).to eq('two')
        end
      end
    end
  end
end
