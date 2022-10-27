import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction(this._addTx);
  final Function _addTx;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) return;

    final _enteredDescription = _descriptionController.text;
    final _enteredAmount = double.parse(_amountController.text);
    final _enteredDate = _selectedDate;

    if (_enteredDescription.isEmpty ||
        _enteredAmount <= 0 ||
        _enteredDate == null) {
      return;
    }

    widget._addTx(
      _enteredDescription,
      _enteredAmount,
      _enteredDate,
    );

    Navigator.of(context).pop();
  }

  var _isSubmissionValid;

  void _checkForValidSubmission() {
    setState(() {
      if (_descriptionController.text.isEmpty ||
          _amountController.text.isEmpty ||
          _selectedDate == null) {
        _isSubmissionValid = false;
      } else {
        _isSubmissionValid = true;
      }
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description (ie. "Nike Store")',
                ),
                controller: _descriptionController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount (ie. 189.99)',
                ),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'Date: None selected yet...'
                          : 'Date: ${DateFormat.yMd().format((_selectedDate as DateTime))}'),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: const Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isSubmissionValid == false)
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Entry is missing value(s) for: ' +
                            (_descriptionController.text.isEmpty
                                ? 'description, '
                                : '') +
                            (_amountController.text.isEmpty ? 'amount, ' : '') +
                            (_selectedDate == null ? 'date' : ''),
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Cancel'),
                  ),
                  Expanded(
                    child: FittedBox(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submitData();
                      _checkForValidSubmission();
                    },
                    child: const Text(
                      'Add Transaction',
                    ),
                  ),
                ],
              ),
              if (MediaQuery.of(context).viewInsets.bottom == 0)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
