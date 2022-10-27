import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  Chart(this._recentTransactions);
  final List<Transaction> _recentTransactions;

  List<Map<String, Object>> get _groupedTransactionValues {
    return List.generate(7, (index) {
      final _weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var _totalSum = 0.0;
      for (var tx in _recentTransactions) {
        if (tx.date.day == _weekDay.day &&
            tx.date.month == _weekDay.month &&
            tx.date.year == _weekDay.year) {
          _totalSum += tx.amount;
        }
      }

      final _dateUnformatted = DateFormat.E().format(_weekDay);
      final String _dateFormatted;

      if (_dateUnformatted != 'Mon' &&
          _dateUnformatted != 'Wed' &&
          _dateUnformatted != 'Fri') {
        _dateFormatted = _dateUnformatted.substring(0, 2);
      } else {
        _dateFormatted = _dateUnformatted.substring(0, 1);
      }

      return {
        'day': _dateFormatted,
        'amount': _totalSum,
      };
    }).reversed.toList();
  }

  double get _maxSpending {
    return _groupedTransactionValues.fold(
      0.0,
      (previousValue, element) {
        return previousValue + (element['amount'] as double);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 15),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'] as String,
                  data['amount'] as double,
                  _maxSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / _maxSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
