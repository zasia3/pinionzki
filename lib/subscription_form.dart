import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'subscription_model.dart';
import 'currency_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'currency_model.dart';
import 'frequency_picker.dart';
import 'frequency_model.dart';

class SubscriptionForm extends StatefulWidget {
  SubscriptionForm({Key key, this.subscription}) : super(key: key);

  final Subscription subscription;
  @override
  _SubscriptionFormState createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Currency _currency;
  Frequency _frequency;
  String _name;
  double _amount;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.subscription != null) {
      nameController.text = widget.subscription.name;
      amountController.text = widget.subscription.value.toString();
      if (widget.subscription.currency != null) {
        _currency = currencyFromAbbreviation(widget.subscription.currency);
      }
    }
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: widget.subscription != null ? Text('Edit subscription') : Text('Add a new subscription'),
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
                controller: nameController,
                decoration: const InputDecoration(
                    icon: const Icon(Icons.add),
                    hintText: "Enter subscription name",
                    labelText: "Name"),
                validator: (val) => val.isEmpty ? 'Name is required' : null,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(20)
                ],
                onSaved: (val) => _name = val,

              ),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                    icon: const Icon(Icons.confirmation_number),
                    hintText: "Enter amount",
                    labelText: "Amount"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) => val.isEmpty ? 'Amount is required' : null,
                onSaved: (val) => _amount = double.parse(val),
              ),
              CurrencyPicker(
                notifyParent: (Currency currency) => {
                      setState(() {
                        _currency = currency;
                      })
                    },
                currentCurrencyAbbreviation: _currency.abbreviation,
              ),
              FrequencyPicker(
                notifyParent: (Frequency frequency) => {
    setState(() {
    _frequency = frequency;
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
          )),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      if (widget.subscription == null) {
        addSubscription();
      } else {
        updateSubscription();
      }
    }
  }

  void updateSubscription() {
    widget.subscription.reference.updateData(subscriptionMap());
    Navigator.pop(context);
  }

  void addSubscription() {
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference subscriptions =
      Firestore.instance.collection('subscriptions');
      await subscriptions.add(subscriptionMap());
      Navigator.pop(context);
    });
  }

  Map<String, dynamic> subscriptionMap() {
    return {
      'name': nameController.text,
      'amount': double.parse(amountController.text),
      'currency': _currency.abbreviation
    };
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}
