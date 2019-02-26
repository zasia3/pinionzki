import 'package:flutter/material.dart';
import 'subscription_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSubscriptionFormPage extends StatefulWidget {

  @override
  _AddSubscriptionFormPageState createState() => _AddSubscriptionFormPageState();
}

class _AddSubscriptionFormPageState extends State<AddSubscriptionFormPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController currencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new subscription'),
      ),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 30,
            ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: nameController,
                  onChanged: (v) => nameController.text = v,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: amountController,
                    onChanged: (v) => amountController.text = v,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                  )
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: currencyController,
                    onChanged: (v) => currencyController.text = v,
                    decoration: InputDecoration(
                      labelText: 'Currency',
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return RaisedButton(
                      onPressed: () => Firestore.instance.runTransaction((transaction) async {
                        CollectionReference subscriptions = Firestore.instance.collection('subscriptions');
                        var _result = await subscriptions.add(
                            {
                              'name': nameController.text,
                              'amount': double.parse(amountController.text),
                              'currency': currencyController.text
                            });
                        Navigator.pop(context);
                    }),
                      color: Colors.indigoAccent,
                      child: Text('Submit subscription'),
                    );
                  },
                ),
              ),
            ]
          )
        ),
      )
    );
  }


}