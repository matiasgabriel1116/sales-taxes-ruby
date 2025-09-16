# frozen_string_literal: true

require 'bigdecimal'

module SalesTaxes
  class Formatter
    def format(receipt)
      out = []
      receipt.lines.each do |line|
        out << "#{line.quantity} #{line.name}: #{money(line.line_total)}"
      end
      out << "Sales Taxes: #{money(receipt.sales_taxes)}"
      out << "Total: #{money(receipt.total)}"
      out.join("\n")
    end

    private

    def money(amount)
      Kernel.format('%.2f', amount.round(2).to_f)
    end
  end
end
