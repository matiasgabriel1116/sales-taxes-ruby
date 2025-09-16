# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

module SalesTaxes
  class Product
    attr_reader :name, :price, :imported

    EXEMPT_KEYWORDS = %w[book books chocolate chocolates bar pill pills headache].freeze

    def initialize(name:, price:, imported: false)
      @name = name.freeze
      @price = BigDecimal(price.to_s)
      @imported = !!imported
      freeze
    end

    def imported?
      @imported
    end

    # Simple keyword-based classifier aligned with the kata
    def exempt?
      tokens = name.downcase.split
      (tokens & EXEMPT_KEYWORDS).any?
    end
  end
end
