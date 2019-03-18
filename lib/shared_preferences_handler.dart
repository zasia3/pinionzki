import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'currency_model.dart';

final String kAppCurrency = "appCurrency";
final String kExchangeRatesCheckDate = "exchangeRatesCheckDate";
final String kExchangeRatesBaseCurrency = "exchangeRatesBaseCurrency";

class SharedPreferencesHelper {

  static Future<String> getAppCurrency() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getting prefs in getcurrency");
    return prefs.getString(kAppCurrency) ?? currencies.first.abbreviation;
  }

  static Future<bool> setAppCurrency(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Future<bool> setCurrency =  prefs.setString(kAppCurrency, value);
    print('Set currency: $setCurrency');

    return setCurrency;
  }
}

class SharedPreferencesBuilder<T> extends StatelessWidget {
  final String pref;
  final AsyncWidgetBuilder<T> builder;

  const SharedPreferencesBuilder({
    Key key,
    @required this.pref,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: _future(),
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          return this.builder(context, snapshot);
        });
  }

  Future<T> _future() async {
    return (await SharedPreferences.getInstance()).get(pref);
  }
}