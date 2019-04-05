import 'package:cloud_firestore/cloud_firestore.dart';
import 'frequency_model.dart';

class Subscription {
  String name;
  double value;
  String currency;
  Frequency frequency;
  DateTime startDate;
  DocumentReference reference;

  Subscription(this.name, this.value, this.currency, this.frequency, this.startDate, this.reference);

  Subscription.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['amount'] != null),
        assert(map['currency'] != null),
        assert(map['frequency'] != null),
        assert(map['start_date'] != null),
        name = map['name'],
        value = map['amount'],
        currency = map['currency'],
        frequency = map['frequency'],
        startDate = map['start_date'];

  Subscription.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}