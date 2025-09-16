# frozen_string_literal: true

require 'bigdecimal'
require_relative 'rounding'

module SalesTaxes
  class TaxCalculator
    def initialize(policies:)
      @policies = policies.freeze
      freeze
    end

    # Returns [unit_tax, unit_price_with_tax, line_tax_total, line_total]
    def breakdown_for(line_item)
      product = line_item.product
      rate = @policies.sum { |p| p.rate_for(product) }
      unit_tax = Rounding.ceil_to_nearest_0_05(product.price * rate)
      unit_price_with_tax = product.price + unit_tax
      qty = line_item.quantity
      line_tax_total = unit_tax * qty
      line_total = unit_price_with_tax * qty
      [unit_tax, unit_price_with_tax, line_tax_total, line_total]
    end
  end
end
