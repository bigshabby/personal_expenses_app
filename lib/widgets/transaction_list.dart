import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/transaction_item.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  TransactionList(this._transactions, this._deleteTx, this._txEditorEnabled,
      this._refreshFx);
  final List<Transaction> _transactions;
  final Function _deleteTx;
  final _txEditorEnabled;
  final VoidCallback _refreshFx;

  void _changeIsChecked(index) {
    _transactions[index].isChecked ^= true;
  }

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.13),
                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.width * 0.55,
                child: Image.asset(
                  'assets/images/financial_statement.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                  bottom: 8,
                ),
                child: const Text(
                  'UH OH! No transactions have been added yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const Text("You can add one by tapping on the '+' icon"),
            ],
          )
        : ListView.builder(
            padding: EdgeInsets.only(bottom: 130),
            itemBuilder: (context, index) {
              return TransactionItem(
                key: ValueKey(_transactions[index].id),
                transactions: _transactions,
                index: index,
                changeIsChecked: _changeIsChecked,
                refreshFx: _refreshFx,
                txEditorEnabled: _txEditorEnabled,
                deleteTxFx: _deleteTx,
              );
            },
            itemCount: _transactions.length,
          );
  }
}
