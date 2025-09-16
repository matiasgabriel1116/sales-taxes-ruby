# frozen_string_literal: true

require 'bigdecimal'

module SalesTaxes
  class LineItem
    attr_reader :quantity, :product

    def initialize(quantity:, product:)
      @quantity = Integer(quantity)
      @product = product
      freeze
    end
  end
end
