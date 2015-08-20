module Securetrading
  class Response < BaseModel
    attr_reader :httparty

    def initialize(httparty)
      @httparty = httparty
    end

    def data
      rows.map { |row| Record.new(row) }
    end

    def found
      attributes_hash['found'].to_i
    end

    private

    def rows
      case found
      when 0 then []
      when 1 then [record]
      else record
      end
    end

    def attributes_hash
      return @attributes_hash if @attributes_hash.present?
      @attributes_hash = responseblock
      @attributes_hash.merge!(additional_attributes)
    end

    def additional_attributes
      if responseblock['type'] == 'ERROR'
        {}
      elsif responseblock['response']['type'] == 'TRANSACTIONQUERY'
        @attributes_hash.delete('response')
      else
        { 'record' => @attributes_hash.delete('response'), 'found' => '1' }
      end
    end

    def responseblock
      @responseblock ||= @httparty.parsed_response['responseblock']
    end
  end
end
