module Securetrading
  class Refund < Connection
    def initialize(amount, parent_transaction, options = {})
      @amount = amount
      @parent_transaction = parent_transaction
      @account_type = options[:account_type].presence || 'ECOM'
      @options = options
    end

    def perform(options = {})
      perform_with(:post, to_xml, options)
    end

    private

    def ox_xml
      prepare_doc do
        req = doc.requestblock.request
        req << merchant << operation << billing
      end
    end

    def request_type
      'REFUND'.freeze
    end

    def operation
      XmlDoc.elements(
        operation: {
          sitereference: Securetrading.config.site_reference,
          accounttypedescription: @account_type,
          parenttransactionreference: @parent_transaction
        }
      ).first
    end

    def billing
      XmlDoc.elements(billing: { amount: @amount }).first
    end

    def merchant
      return '' unless @options[:merchant].present?
      XmlDoc.elements(merchant: @options[:merchant]).first
    end
  end
end
