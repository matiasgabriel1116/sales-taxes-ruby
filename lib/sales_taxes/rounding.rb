# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

module SalesTaxes
  module Rounding
    module_function

    # Round up (ceiling) to the nearest 0.05 using integer arithmetic.
    # Always returns BigDecimal.
    def ceil_to_nearest_0_05(amount)
      n = amount * 20 # scale: 0.05 => 1 unit
      inc = n.frac.zero? ? 0 : 1
      BigDecimal((n.to_i + inc).to_s) / 20
    end
  end
end
