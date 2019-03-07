import 'package:flutter/material.dart';
import 'currency_picker.dart';
import 'currency_model.dart';
import 'shared_preferences_handler.dart';

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
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    String abbreviation = await SharedPreferencesHelper.getAppCurrency();
    print("read abbreviation: $abbreviation");
    setState(() {
      _currency = currencyFromAbbreviation(abbreviation);
      print("created currency: $_currency");
    });
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
                notifyParent: (Currency currency) => {
                  setState(() {
                        _currency = currency;
                      })
                },
                currentCurrency: _currency,
              ),
              new Container(
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

  Widget _buildCurrencyPicker(String currencyAbbreviation) {
    Currency _savedCurrency;
    if (currencyAbbreviation != null) {
      _savedCurrency = currencyFromAbbreviation(currencyAbbreviation);
    } else {
      _savedCurrency = currencies.first;
    }
    return CurrencyPicker(
      notifyParent: (Currency currency) => {
            setState(() {
              _currency = currency;
            })
          },
      currentCurrency: _savedCurrency,
    );
  }
}
