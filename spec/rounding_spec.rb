# frozen_string_literal: true

require 'bigdecimal'
require_relative '../lib/sales_taxes/rounding'

RSpec.describe SalesTaxes::Rounding do
  it 'rounds up to nearest 0.05' do
    expect(described_class.ceil_to_nearest_0_05(BigDecimal('1.499'))).to eq(BigDecimal('1.50'))
    expect(described_class.ceil_to_nearest_0_05(BigDecimal('0.5625'))).to eq(BigDecimal('0.60'))
    expect(described_class.ceil_to_nearest_0_05(BigDecimal('0'))).to eq(BigDecimal('0'))
  end
end
