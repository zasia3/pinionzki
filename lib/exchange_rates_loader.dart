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

  final difference = today.difference(today);
  print ('difference in days: $difference');
//  if (difference.inDays < 1 && lastCheckedCurrencyAbbreviation == currencyAbbreviation) return;

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');
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
    ExchangeRates rates = ExchangeRates.fromJson(jsonDecode(jsonString));

    return rates;
  } catch (e) {
    print("Couldn't read file");
  }
}

Future<double>getTotal(List<DocumentSnapshot> documents) async {
  await loadExchangeRates();
  ExchangeRates rates = await getExchangeRates();

  print(rates);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String currencyAbbreviation = prefs.getString(kAppCurrency) ?? currencies.first.abbreviation;

  double total = 0;

  documents.forEach( (document ) {
     double amount = document.data['amount'];
     String currency = document.data['currency'];
//     if (currency == rates.baseRate) {
       total += amount;
//     } else {
//       double rate = rates.rates[currency];
//       total += amount * rate;
//     }
  });

  return total;
}
