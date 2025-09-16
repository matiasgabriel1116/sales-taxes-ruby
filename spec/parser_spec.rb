# frozen_string_literal: true

require_relative '../lib/sales_taxes/parser'

RSpec.describe SalesTaxes::Parser do
  it 'parses a valid line' do
    item = described_class.new.parse(["1 imported bottle of perfume at 47.50\n"]).first
    expect(item.quantity).to eq(1)
    expect(item.product.name).to eq('imported bottle of perfume')
    expect(item.product.imported?).to be true
  end

  it 'raises on invalid line' do
    expect { described_class.new.parse(["foo bar\n"]) }.to raise_error(ArgumentError)
  end
end
