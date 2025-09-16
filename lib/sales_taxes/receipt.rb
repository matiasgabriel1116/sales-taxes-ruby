# frozen_string_literal: true

require 'bigdecimal'

module SalesTaxes
  ReceiptLine = Struct.new(:quantity, :name, :line_total, keyword_init: true)

  class Receipt
    attr_reader :lines, :sales_taxes, :total

    def initialize(lines:, sales_taxes:, total:)
      @lines = lines.freeze
      @sales_taxes = sales_taxes
      @total = total
      freeze
    end

    def self.build(line_items, calculator:)
      lines = []
      taxes_sum = BigDecimal('0')
      total_sum = BigDecimal('0')

      line_items.each do |li|
        _unit_tax, _unit_price, line_tax_total, line_total = calculator.breakdown_for(li)
        lines << ReceiptLine.new(quantity: li.quantity, name: li.product.name, line_total: line_total)
        taxes_sum += line_tax_total
        total_sum += line_total
      end

      new(lines: lines, sales_taxes: taxes_sum, total: total_sum)
    end
  end
end
