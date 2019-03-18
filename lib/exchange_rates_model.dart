class ExchangeRates {
  final String baseRate;
  final String date;
  final Map<String, double> rates;

  ExchangeRates(this.baseRate, this.date, this.rates);

  ExchangeRates.fromJson(Map<String, dynamic>json)
      : assert(json['base'] != null),
        assert(json['date'] != null),
        assert(json['rates'] != null),
        baseRate = json['base'],
        date = json['date'],
        rates = json['rates'].cast<String, double>();
}