import 'frequency_model.dart';
import 'package:flutter/material.dart';

typedef void FrequencyArgument(Frequency x);

class FrequencyPicker extends StatefulWidget {
  final FrequencyArgument notifyParent;
  final Frequency currentFrequency;

  FrequencyPicker({Key key, @required this.notifyParent, this.currentFrequency}) : super(key: key);
  @override
  _FrequencyPickerState createState() => _FrequencyPickerState();
}

class _FrequencyPickerState extends State<FrequencyPicker> {
  Frequency _frequency;

  @override
  void initState() {
    if (widget.currentFrequency != null) {
      _frequency = widget.currentFrequency;
//      print("setting state with currency: $_currency");
    }
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Frequency>(
      builder: (FormFieldState<Frequency> state) {
        return InputDecorator(
            decoration: InputDecoration(
                icon: const Icon(Icons.attach_money),
                labelText: "Frequency"
            ),
            isEmpty: _frequency == null,

            child: DropdownButtonHideUnderline(
                child: DropdownButton<Frequency>(
                  value: _frequency,
                  isDense: true,
                  onChanged: (Frequency newValue) {
                    setState(() {
                      _frequency = newValue;
                      state.didChange(newValue);
                    });
                    widget.notifyParent(newValue);
                  },
                  items: frequencies.map((Frequency frequency) {
                    return new DropdownMenuItem(
                        value: frequency,
                        child: Text(frequency.name));
                  }).toList(),
                )
            )
        );

      },
      validator: (val) {
        return val != null ? null : 'Please select frequency';
      },
    );
  }
}