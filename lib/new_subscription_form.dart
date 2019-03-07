import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'subscription_model.dart';
import 'currency_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'currency_model.dart';

class AddSubscriptionFormPage extends StatefulWidget {

  @override
  _AddSubscriptionFormPageState createState() => _AddSubscriptionFormPageState();
}

class _AddSubscriptionFormPageState extends State<AddSubscriptionFormPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController currencyController = TextEditingController();

  Currency _currency;
  String _name;
  double _amount;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add a new subscription'),
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
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.add),
                  hintText: "Enter subscription name",
                  labelText: "Name"
                ),
                validator: (val) => val.isEmpty ? 'Name is required' : null,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(20)
                ],
                onSaved: (val) => _name = val,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    icon: const Icon(Icons.confirmation_number),
                    hintText: "Enter amount",
                    labelText: "Amount"
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) => val.isEmpty ? 'Amount is required' : null,
                onSaved: (val) => _amount = double.parse(val),
              ),
              CurrencyPicker(notifyParent: (Currency currency) => {
                  setState(() {
                    _currency = currency;
                  })
                },
              ),
              new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  onPressed: _submitForm,
                ),
              )
            ],
          )
      ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      Firestore.instance.runTransaction((transaction) async {
        CollectionReference subscriptions = Firestore.instance.collection('subscriptions');
        await subscriptions.add({
          'name': _name,
          'amount': _amount,
          'currency': _currency.abbreviation
        });
        Navigator.pop(context);
      });
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }


}