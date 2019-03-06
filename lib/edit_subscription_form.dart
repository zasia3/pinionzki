import 'package:flutter/material.dart';
import 'subscription_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditSubscriptionFormPage extends StatefulWidget {
  EditSubscriptionFormPage({Key key, @required this.subscription}) : super(key: key);

  final Subscription subscription;
  @override
  _EditSubscriptionFormPageState createState() => _EditSubscriptionFormPageState(subscription);
}

class _EditSubscriptionFormPageState extends State<EditSubscriptionFormPage> {
  final Subscription subscription;
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  _EditSubscriptionFormPageState(this.subscription);

  @override
  void initState() {
    nameController.text = subscription.name;
    amountController.text = subscription.value.toString();
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit subscription'),
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
                      padding: const EdgeInsets.all(16.0),
                      child: Builder(
                        builder: (context) {
                          // The basic Material Design action button.
                          return RaisedButton(
                            onPressed: () => subscription.reference.updateData({
                              'name': nameController.text,
                              'amount': double.parse(amountController.text)
                            }),
                            color: Colors.indigoAccent,
                            child: Text('Save'),
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