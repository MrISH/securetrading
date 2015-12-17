module Securetrading
  class TransactionQuery < Connection
    def initialize(filters, config_options = {})
      @filters = filters
      @config_options = config_options
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
