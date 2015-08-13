require 'spec_helper'

describe Securetrading::Filter do
  let(:filters) { {} }
  let(:filter) { described_class.new(filters) }

  describe '#perform' do
    before do
      allow(filter).to receive(:to_xml) { '<xml>' }
    end

    it 'calls perform_with using :post' do
      expect(filter).to receive(:perform_with).with(:post, '<xml>', {})
      filter.perform
    end
  end

  describe '#to_xml' do
    let(:expected_xml) do
      "\n<requestblock version=\"3.67\">\n"\
        "  <alias>u</alias>\n"\
        "  <request type=\"TRANSACTIONQUERY\">\n"\
        "    <filter>\n"\
        "      <transactionreference>5-9-1982481</transactionreference>\n"\
        "      <transactionreference>5-9-1980795</transactionreference>\n"\
        "    </filter>\n"\
        "  </request>\n"\
        "</requestblock>\n"
    end

    let(:filters) { { transactionreference: ['5-9-1982481', '5-9-1980795'] } }

    it 'returns xml representation of filter' do
      expect(filter.to_xml).to eq(expected_xml)
    end
  end
end
