import 'currency_model.dart';
import 'package:flutter/material.dart';

class CurrencyPicker extends StatefulWidget {
  final Function() notifyParent;

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
                    widget.notifyParent();
                  },

//                  onChanged: (Currency newValue) {
//                    setState(() {
//                      _currency = newValue;
//                      state.didChange(newValue);
//                    });
//                  },
                  items: currencies.map((Currency currency) {
                    return new DropdownMenuItem(
                      value: currency,
                        child: Text(currency.name),
                    );
                  }).toList(),
                )
            )
        );

      }
    );
//    return ListWheelScrollView.useDelegate(
//        itemExtent: 10,
//        childDelegate: ListWheelChildLoopingListDelegate(
//            children: List<Widget>.generate(
//                currencies.length, (index) => Text(currencies[index].name),
//            )
//        ),
//    );
  }
}