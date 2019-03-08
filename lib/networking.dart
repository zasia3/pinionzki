import 'package:http/http.dart' as http;
import 'dart:async';
import 'exchange_rates_model.dart';
import 'dart:convert';

Future<String> getLatestCurrencies(String baseCurrency) async {
  String url = baseCurrency == null ? 'https://api.exchangeratesapi.io/latest' : 'https://api.exchangeratesapi.io/latest?base=$baseCurrency';
  final response = await http.get(url);

  if (response.statusCode == 200) {
    print('received exchange rates: ${response.body}');
    return response.body;
  } else {
    throw Exception('Failed to load exchange rates');
  }
}