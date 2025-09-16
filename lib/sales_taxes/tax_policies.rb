# frozen_string_literal: true

require 'bigdecimal'

module SalesTaxes
  class BasicSalesTax
    RATE = BigDecimal('0.10')

    def rate_for(product)
      product.exempt? ? BigDecimal('0') : RATE
    end
  end

  class ImportDuty
    RATE = BigDecimal('0.05')

    def rate_for(product)
      product.imported? ? RATE : BigDecimal('0')
    end
  end
end
