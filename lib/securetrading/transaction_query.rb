module Securetrading
  class TransactionQuery < Connection
    def initialize(filters)
      @filters = filters
    end

    def perform(options = {})
      perform_with(:post, to_xml, options)
    end

    private

    def ox_xml
      prepare_doc do
        doc.requestblock.request << XmlDoc.elements(filter: @filters).first
      end
    end

    def request_type
      'TRANSACTIONQUERY'.freeze
    end
  end
end
