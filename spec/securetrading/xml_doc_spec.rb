require 'spec_helper'

describe Securetrading::XmlDoc do
  describe '.elements' do
    let(:tags) { { tag: 'first' } }
    let(:elements) { described_class.elements(tags) }

    it 'return array of Ox::Element' do
      expect(elements.first).to be_a(Ox::Element)
    end

    it 'returns elements with key as tag and value as nested text' do
      expect(elements.first.name).to eq('tag')
      expect(elements.first.nodes.first).to eq('first')
    end

    context 'when argument is nested hash' do
      let(:tags) { { tag: { subtag: 'text', subtag2: 'text2' } } }
      let(:expected_xml) do
        "\n<tag>\n  <subtag>text</subtag>\n  <subtag2>text2</subtag2>\n</tag>\n"
      end

      it 'returns defined ox elements tree' do
        expect(Ox.dump(elements.first)).to eq(expected_xml)
      end
    end
  end

  describe '.new_element' do
    let(:element) { described_class.new_element('name') }
    it 'returns Ox::Element with name' do
      expect(element).to be_a(Ox::Element)
      expect(element.name).to eq('name')
    end
  end

  describe '#doc' do
    let(:doc) { described_class.new('REFUND', 'ECOM').doc }

    it 'returns prepared Ox::Document' do
      expect(doc).to be_a(Ox::Document)
    end

    context 'dumped to xml' do
      let(:expected_xml) do
        "\n<requestblock version=\"3.67\">\n"\
          "  <alias>u</alias>\n"\
          "  <request type=\"REFUND\"/>\n"\
          "</requestblock>\n"
      end

      it 'returns predefined xml structure' do
        expect(Ox.dump(doc)).to eq(expected_xml)
      end
    end
  end
end
