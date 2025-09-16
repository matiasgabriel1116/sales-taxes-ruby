# frozen_string_literal: true

require 'bigdecimal'
require_relative '../lib/sales_taxes/product'
require_relative '../lib/sales_taxes/line_item'
require_relative '../lib/sales_taxes/tax_policies'
require_relative '../lib/sales_taxes/tax_calculator'

RSpec.describe SalesTaxes::TaxCalculator do
  let(:policies) { [SalesTaxes::BasicSalesTax.new, SalesTaxes::ImportDuty.new] }
  let(:calculator) { described_class.new(policies: policies) }

  it 'applies no tax to exempt domestic products' do
    product = SalesTaxes::Product.new(name: 'book', price: BigDecimal('12.49'))
    li = SalesTaxes::LineItem.new(quantity: 2, product: product)
    _ut, _up, taxes, total = calculator.breakdown_for(li)
    expect(taxes).to eq(BigDecimal('0'))
    expect(total).to eq(BigDecimal('24.98'))
  end

  it 'applies 10% basic tax to non-exempt domestic products' do
    product = SalesTaxes::Product.new(name: 'music CD', price: BigDecimal('14.99'))
    li = SalesTaxes::LineItem.new(quantity: 1, product: product)
    _ut, _up, taxes, total = calculator.breakdown_for(li)
    expect(taxes).to eq(BigDecimal('1.50'))
    expect(total).to eq(BigDecimal('16.49'))
  end

  it 'applies 5% import duty to imported exempt products' do
    product = SalesTaxes::Product.new(name: 'imported box of chocolates', price: BigDecimal('10.00'), imported: true)
    li = SalesTaxes::LineItem.new(quantity: 1, product: product)
    _ut, _up, taxes, total = calculator.breakdown_for(li)
    expect(taxes).to eq(BigDecimal('0.50'))
    expect(total).to eq(BigDecimal('10.50'))
  end
end
