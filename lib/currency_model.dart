class Currency {
  final String name;
  final String abbreviation;
  final String symbol;

  Currency(this.name, this.abbreviation, this.symbol);

}

final List<Currency> currencies = [
  Currency('Zloty', 'PLN', 'PLN'),
  Currency('Pound Sterling', 'GBP', '£'),
  Currency('Dollar', 'USD', "\$")
];

Currency currencyFromAbbreviation(String abbreviation) {
  return currencies.firstWhere((currency) => currency.abbreviation == abbreviation);
}