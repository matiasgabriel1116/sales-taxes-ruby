# frozen_string_literal: true

require 'bigdecimal'
require_relative 'product'
require_relative 'line_item'

module SalesTaxes
  class Parser
    LINE_REGEX = /\A\s*(\d+)\s+(.+?)\s+at\s+(\d+(?:\.\d+)?)\s*\z/i.freeze

    def parse(lines)
      Array(lines).map do |line|
        match = LINE_REGEX.match(line)
        raise ArgumentError, "Invalid line: #{line.strip}" unless match

        qty = match[1]
        name = match[2].strip
        price = BigDecimal(match[3])
        imported = name.downcase.include?('imported')
        # Keep name as provided (including 'imported' when present)
        product = Product.new(name: name, price: price, imported: imported)
        LineItem.new(quantity: qty, product: product)
      end
    end
  end
end
