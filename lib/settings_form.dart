import 'package:flutter/material.dart';
import 'currency_picker.dart';
import 'currency_model.dart';
import 'shared_preferences_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  Currency _currency;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 30,
            ),
            children: <Widget>[
              CurrencyPicker(
                notifyParent: _saveCurrency,
                currentCurrencyAbbreviation: _currency.abbreviation,
              ),
              Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    print(_currency.abbreviation);
                    await SharedPreferencesHelper.setAppCurrency(
                        _currency.abbreviation);
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          )),
    );
  }

  _loadCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currencyAbbreviation = prefs.getString(kAppCurrency);
    setState(() {
      if (currencyAbbreviation != null) {
        _currency = currencyFromAbbreviation(currencyAbbreviation);
      } else {
        _currency = currencies.first;
      }
    });
  }

  _saveCurrency(Currency currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currency = currency;
      prefs.setString('_kAppCurrency', _currency.abbreviation);
    });
  }
}
