import 'currency_model.dart';
import 'package:flutter/material.dart';

typedef void CurrencyArgument(Currency x);

class CurrencyPicker extends StatefulWidget {
  final CurrencyArgument notifyParent;

  CurrencyPicker({Key key, @required this.notifyParent}) : super(key: key);
  @override
  _CurrencyPickerState createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  Currency _currency;
 
  @override
  Widget build(BuildContext context) {
    return FormField<Currency>(
      builder: (FormFieldState<Currency> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.attach_money),
            labelText: "Currency"
          ),
            isEmpty: _currency == null,

            child: DropdownButtonHideUnderline(
                child: DropdownButton<Currency>(
                  value: _currency,
                  isDense: true,
                  onChanged: (Currency newValue) {
                    setState(() {
                      _currency = newValue;
                      state.didChange(newValue);
                    });
                    widget.notifyParent(newValue);
                  },
                  items: currencies.map((Currency currency) {
                    return new DropdownMenuItem(
                      value: currency,
                        child: Text(currency.name),
                    );
                  }).toList(),
                )
            )
        );

      },
      validator: (val) {
        return val != null ? null : 'Please select a color';
      },
    );
  }
}