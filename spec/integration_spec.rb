# frozen_string_literal: true

require_relative '../lib/sales_taxes/parser'
require_relative '../lib/sales_taxes/tax_policies'
require_relative '../lib/sales_taxes/tax_calculator'
require_relative '../lib/sales_taxes/receipt'
require_relative '../lib/sales_taxes/formatter'

RSpec.describe 'Integration' do
  def run(lines)
    parser = SalesTaxes::Parser.new
    items = parser.parse(lines)
    policies = [SalesTaxes::BasicSalesTax.new, SalesTaxes::ImportDuty.new]
    calc = SalesTaxes::TaxCalculator.new(policies: policies)
    SalesTaxes::Formatter.new.format(SalesTaxes::Receipt.build(items, calculator: calc))
  end

  it 'produces Output 1' do
    lines = [
      "2 book at 12.49\n",
      "1 music CD at 14.99\n",
      "1 chocolate bar at 0.85\n"
    ]
    expect(run(lines)).to eq(
      "2 book: 24.98\n"       "1 music CD: 16.49\n"       "1 chocolate bar: 0.85\n"       "Sales Taxes: 1.50\n"       "Total: 42.32"
    )
  end

  it 'produces Output 2' do
    lines = [
      "1 imported box of chocolates at 10.00\n",
      "1 imported bottle of perfume at 47.50\n"
    ]
    expect(run(lines)).to eq(
      "1 imported box of chocolates: 10.50\n"       "1 imported bottle of perfume: 54.65\n"       "Sales Taxes: 7.65\n"       "Total: 65.15"
    )
  end

  it 'produces Output 3' do
    lines = [
      "1 imported bottle of perfume at 27.99\n",
      "1 bottle of perfume at 18.99\n",
      "1 packet of headache pills at 9.75\n",
      "3 imported boxes of chocolates at 11.25\n"
    ]
    expect(run(lines)).to eq(
      "1 imported bottle of perfume: 32.19\n"       "1 bottle of perfume: 20.89\n"       "1 packet of headache pills: 9.75\n"       "3 imported boxes of chocolates: 35.55\n"       "Sales Taxes: 7.90\n"       "Total: 98.38"
    )
  end
end
