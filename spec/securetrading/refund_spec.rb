require 'spec_helper'

describe Securetrading::Refund do
  let(:options) { {} }
  let(:refund) { described_class.new(100, 'parent', options) }

  describe '#perform' do
    before do
      allow(refund).to receive(:to_xml) { '<xml>' }
    end

    it 'calls perform_with using :post' do
      expect(refund).to receive(:perform_with).with(:post, '<xml>', {})
      refund.perform
    end
  end

  describe '#to_xml' do
    # rubocop:disable Metrics/LineLength
    let(:expected_xml) do
      "\n<requestblock version=\"3.67\">\n"\
        "  <alias>u</alias>\n"\
        "  <request type=\"REFUND\">\n"\
        "    <operation>\n"\
        "      <sitereference>sr</sitereference>\n"\
        "      <accounttypedescription>ECOM</accounttypedescription>\n"\
        "      <parenttransactionreference>parent</parenttransactionreference>\n"\
        "    </operation>\n"\
        "    <billing>\n"\
        "      <amount>100</amount>\n"\
        "    </billing>\n"\
        "  </request>\n"\
        "</requestblock>\n"
    end
    # rubocop:enable Metrics/LineLength

    it 'returns xml representation of refund' do
      expect(refund.to_xml).to eq(expected_xml)
    end

    context 'with account_type option' do
      let(:options) { { account_type: 'CFT' } }

      it 'returns xml with accounttypedescription tag' do
        expect(refund.to_xml)
          .to include('<accounttypedescription>CFT</accounttypedescription>')
      end
    end

    context 'with merchant option' do
      let(:options) { { merchant: { orderreference: 'orderId1' } } }
      let(:merchant_tag) do
        "    <merchant>\n"\
        "      <orderreference>orderId1</orderreference>\n"\
        '    </merchant>'
      end

      it 'returns xml representation of refund with merchant tag' do
        expect(refund.to_xml).to include(merchant_tag)
      end
    end
  end
end
