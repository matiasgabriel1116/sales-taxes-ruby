# Sales Taxes (Ruby)

A small, production-quality Ruby solution for the classic *Sales Taxes* problem.

- **No frameworks** (no Rails); Ruby **3.3+**.
- **Object-oriented** with **composition** (policies) instead of inheritance.
- **Thread-safe by default** (immutable value objects, no global mutable state).
- **Deterministic rounding** using `BigDecimal` and a strict "round up to 0.05" helper.
- **Well-tested** using RSpec.
- **No over-engineering**—just the right pieces: parser, domain objects, calculator, and formatter.

---

## How to run

```bash
# 1) Install Ruby 3.3.x (or set local Ruby to 3.3.1)
# 2) Install dev deps
bundle install

# 3) Run tests
bundle exec rspec

# 4) Run the CLI with any input (reads STDIN or file args)
# Example A: echo + heredoc
bin/receipt <<'EOF'
2 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85
EOF

# Example B: from a text file
# bin/receipt path/to/input.txt
```

### Expected outputs for sample inputs

**Input 1**
```
2 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85
```
**Output 1**
```
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32
```

**Input 2**
```
1 imported box of chocolates at 10.00
1 imported bottle of perfume at 47.50
```
**Output 2**
```
1 imported box of chocolates: 10.50
1 imported bottle of perfume: 54.65
Sales Taxes: 7.65
Total: 65.15
```

**Input 3**
```
1 imported bottle of perfume at 27.99
1 bottle of perfume at 18.99
1 packet of headache pills at 9.75
3 imported boxes of chocolates at 11.25
```
**Output 3**
```
1 imported bottle of perfume: 32.19
1 bottle of perfume: 20.89
1 packet of headache pills: 9.75
3 imported boxes of chocolates: 35.55
Sales Taxes: 7.90
Total: 98.38
```

---

## Design overview

- **Parser**: Converts lines like `"1 imported bottle of perfume at 47.50"` into `LineItem(quantity, Product(name, price, imported))`.
- **Product**: Simple immutable value object. `exempt?` is a keyword-based classifier (books, food, medical).
- **Policies (composition)**: `BasicSalesTax` (10% unless exempt) and `ImportDuty` (5% if imported).
- **TaxCalculator**: Sums policy **rates**, computes **per-unit tax**, applies **round-up to 0.05**, multiplies by quantity.
- **Receipt**: Aggregates per-line totals, total taxes, and grand total.
- **Formatter**: Prints exactly as the prompt requires.

**Rounding rule**
> For a tax rate of *n%*, a shelf price *p* contains `ceil_to_0.05(n*p/100)` tax.  
We compute per-item tax using `BigDecimal` and this helper:
```
((amount * 20).ceil / 20)  # i.e., ceil to increments of 0.05
```

**Thread safety**
- All objects are **frozen**; there is no shared mutable state.
- Calculations are pure and deterministic.

---

## Project layout

```
bin/receipt                  # CLI
lib/sales_taxes/*.rb         # domain & utilities
spec/*.rb                    # RSpec tests (unit + integration)
```

---

## Assumptions

- Exempt categories are detected via simple **keyword** matching in the product name:
  - books: `book`, `books`
  - food: `chocolate`, `chocolates`, `bar`
  - medical: `pill`, `pills`, `headache`
- Rounding is applied **per item** after summing applicable rates (10% + 5%).
- Totals are sums of per-line totals (unit price + unit tax) × quantity.
- Formatting is always with **two decimals**.

These assumptions match the sample data and the typical interpretation of the kata.
