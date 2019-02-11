import 'package:flutter/material.dart';
import 'subscription_model.dart';

class SubscriptionCard extends StatefulWidget {
  final Subscription subscription;

  SubscriptionCard(this.subscription);

  @override
  _SubscriptionCardState createState() => _SubscriptionCardState(subscription);
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  Subscription subscription;

  _SubscriptionCardState(this.subscription);
  @override
  Widget build(BuildContext context) {
    return Text(widget.subscription.name);
  }
}