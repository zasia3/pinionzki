import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  final String name;
  final String value;
  final String currency;
  final DocumentReference reference;

  Subscription(this.name, this.value, this.currency, this.reference);

  Subscription.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['amount'] != null),
        assert(map['currency'] != null),
        name = map['name'],
        value = map['amount'],
        currency = map['currency'];


  Subscription.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}