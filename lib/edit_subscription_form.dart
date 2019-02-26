import 'package:flutter/material.dart';
import 'subscription_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditSubscriptionFormPage extends StatefulWidget {

  @override
  _EditSubscriptionFormPageState createState() => _EditSubscriptionFormPageState();
}

class _EditSubscriptionFormPageState extends State<EditSubscriptionFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit subscription'),
      ),
      body: Container(),
    );
  }
}