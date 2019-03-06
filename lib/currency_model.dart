class Currency {
  final String name;
  final String abbreviation;
  final String symbol;

  Currency(this.name, this.abbreviation, this.symbol);

}

final List<Currency> currencies = [
  Currency('zloty', 'PLN', 'PLN'),
  Currency('Pound Sterling', 'GDP', '£'),
  Currency('Dollar', 'USD', "\$")
];