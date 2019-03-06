import 'currency_model.dart';
import 'package:flutter/material.dart';

final List<Currency> currencies = [
  Currency('zloty', 'PLN', 'PLN'),
  Currency('Pound Sterling', 'GDP', '£'),
  Currency('Dollar', 'USD', "\$")
];

class CurrencyPicker extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
        itemExtent: 10,
        childDelegate: ListWheelChildLoopingListDelegate(
            children: List<Widget>.generate(
                currencies.length, (index) => Text(currencies[index].name),
            )
        ),
    );
  }
}