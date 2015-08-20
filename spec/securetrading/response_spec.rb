require 'spec_helper'

describe Securetrading::Response do
  let(:response_block) { {} }
  let(:st_response) { described_class.new(nil) }

  before do
    allow(st_response).to receive(:responseblock) { response_block }
  end

  describe '#found' do
    let(:response_block) do
      { 'version' => '3.67',
        'requestreference' => 'W6-xug',
        'response' => {
          'type' => 'TRANSACTIONQUERY',
          'found' => '1'
        }
      }
    end

    it 'returns number of rows returned' do
      expect(st_response.found).to eq(1)
    end

    context 'when response type is ERROR' do
      let(:response_block) do
        { 'version' => '3.67',
          'requestreference' => 'W6-mwc',
          'type' => 'ERROR',
          'timestamp' => '2015-08-20 14:40:21',
          'error' => {
            'message' => 'Invalid field',
            'code' => '30000',
            'data' => 'transactionreference'
          }
        }
      end

      it 'returns 0' do
        expect(st_response.found).to eq(0)
      end
    end

    context 'when response type is REFUND' do
      let(:response_block) do
        { 'version' => '3.67',
          'requestreference' => 'W4-7h1',
          'response' => { 'type' => 'REFUND' }
        }
      end

      it 'returns 1' do
        expect(st_response.found).to eq(1)
      end
    end
  end

  describe '#data' do
    let(:response_block) do
      { 'version' => '3.67',
        'requestreference' => 'W7-1d',
        'response' => {
          'type' => 'TRANSACTIONQUERY',
          'found' => '2',
          'record' => [
            { 'type' => 'AUTH' },
            { 'type' => 'AUTH' }
          ]
        }
      }
    end

    it 'returns array of Securetrading::Record' do
      expect(st_response.data).to be_a(Array)
      expect(st_response.data.first).to be_a(Securetrading::Record)
    end

    context 'when found returns 0' do
      before do
        allow(st_response).to receive(:found) { 0 }
      end

      it 'returns empty array' do
        expect(st_response.data).to eq([])
      end
    end

    context 'when found returns 1' do
      let(:response_block) do
        { 'version' => '3.67',
          'requestreference' => 'W7-1d',
          'response' => {
            'type' => 'TRANSACTIONQUERY',
            'found' => '1',
            'record' => { 'type' => 'AUTH' }
          }
        }
      end

      it 'returns array with Record' do
        expect(st_response.data.size).to eq(1)
        expect(st_response.data.first.type).to eq('AUTH')
      end
    end
  end
end
