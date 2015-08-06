module SecureTrading
  class Refund < Connection
    def initialize(amount, parent_transaction, options = {})
      @amount = amount
      @parent_transaction = parent_transaction
      @account_type = options[:account_type].presence || 'ECOM'
      @options = options
    end

    def perform(options = {})
      post_with(to_xml, options)
    end

    def to_xml
      Ox.dump(ox_xml)
    end

    private

    def ox_xml
      return doc if xml_prepared?
      req = doc.requestblock.request
      req << merchant << billing
      req.operation << transaction_reference
      @xml_prepared = true
      doc
    end

    def doc
      @doc ||= XmlDoc.new('REFUND', @account_type).doc
    end

    def transaction_reference
      return unless @parent_transaction.present?
      XmlDoc.elements(parenttransactionreference: @parent_transaction).first
    end

    def billing
      XmlDoc.elements(billing: { amount: @amount }).first
    end

    def merchant
      return unless @options[:merchant].present?
      XmlDoc.elements(merchant: @options[:merchant]).first
    end

    def xml_prepared?
      @xml_prepared
    end
  end
end
