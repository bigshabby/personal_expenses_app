import 'package:flutter/material.dart';

class TransactionCheckbox extends StatefulWidget {
  TransactionCheckbox(this._index, this._changeIsChecked, this._resetFx);
  final int _index;
  final Function _changeIsChecked;
  final VoidCallback _resetFx;

  @override
  State<TransactionCheckbox> createState() => _TransactionCheckboxState();
}

class _TransactionCheckboxState extends State<TransactionCheckbox> {
  bool _value = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.purple;
    }
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: this._value,
      onChanged: (bool? value) {
        setState(() {
          this._value = value!;
          widget._changeIsChecked(widget._index);
          widget._resetFx();
        });
      },
      fillColor: MaterialStateProperty.resolveWith(getColor),
      checkColor: Colors.white,
    );
  }
}
