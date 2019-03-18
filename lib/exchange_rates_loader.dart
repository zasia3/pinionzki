import 'networking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_preferences_handler.dart';
import 'currency_model.dart';
import 'exchange_rates_model.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

final String filename = 'exchange_rates_cache.json';

loadExchangeRates() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String currencyAbbreviation = prefs.getString(kAppCurrency) ?? currencies.first.abbreviation;
  String lastCheckedCurrencyAbbreviation = prefs.getString(kExchangeRatesBaseCurrency) ?? currencyAbbreviation;
  int lastCheckTimestamp = prefs.getInt(kExchangeRatesCheckDate) ?? 0;
  bool shouldUpdate = false;
  final date = new DateTime.fromMicrosecondsSinceEpoch(lastCheckTimestamp);
  final today = DateTime.now();

  final Duration difference = today.difference(today);
  print ('difference in days: $difference');
  print ('lastCheckedCurrencyAbbreviation: $lastCheckedCurrencyAbbreviation');
  if (lastCheckTimestamp > 0 && /* difference.inDays < 1 && */lastCheckedCurrencyAbbreviation == currencyAbbreviation) return;

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');
  print ('file: $file');
  String json = await getLatestCurrencies(currencyAbbreviation);
  await file.writeAsString(json);
  print ('json: $json');
  await prefs.setInt(kExchangeRatesCheckDate, today.microsecondsSinceEpoch);
  await prefs.setString(kExchangeRatesBaseCurrency, currencyAbbreviation);
}

Future<ExchangeRates> getExchangeRates() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    String jsonString = await file.readAsString();
    print('jsonString: $jsonString');
    final json = jsonDecode(jsonString);
    print('json decoded: $json');
    ExchangeRates rates = ExchangeRates.fromJson(json);

    return rates;
  } catch (e) {
    print("Couldn't read file: $e");
  }
}

Future<double>getTotal(List<DocumentSnapshot> documents) async {
  await loadExchangeRates();
  ExchangeRates rates = await getExchangeRates();

  print("rates: $rates");

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String currencyAbbreviation = prefs.getString(kAppCurrency) ?? currencies.first.abbreviation;

  double total = 0;

  documents.forEach( (document ) {
     double amount = document.data['amount'];
     String currency = document.data['currency'];

     print('amount: $amount, currency: $currency');

     if (currency == rates.baseRate) {
       total += amount;
     } else {
       double rate = rates.rates[currency] ?? 1;
       print('rate: $rate');
       print('amount * rate = ${amount / rate}');
       total += amount / rate;
     }
  });

  return total;
}
