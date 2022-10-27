import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'transaction_checkbox.dart';
import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    required Key key,
    required this.transactions,
    required this.index,
    required this.changeIsChecked,
    required this.refreshFx,
    required this.txEditorEnabled,
    required this.deleteTxFx,
  }) : super(key: key);
  final List<Transaction> transactions;
  final int index;
  final Function changeIsChecked;
  final VoidCallback refreshFx;
  final bool txEditorEnabled;
  final Function deleteTxFx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  final _formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Card(
        color: Color.fromARGB(255, 254, 240, 253),
        elevation: 2,
        child: ListTile(
          leading: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(75, double.infinity)),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              padding: EdgeInsets.all(10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _formatCurrency
                      .format(widget.transactions[widget.index].amount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          title: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 40),
            child: Text(
              widget.transactions[widget.index].description,
              maxLines: 2,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          subtitle: Text(
            DateFormat.yMMMd().format(widget.transactions[widget.index].date),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
          trailing: widget.txEditorEnabled == false
              ? IconButton(
                  onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                            'Attention!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                              'Do you wish to permanently delete this transaction?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'),
                            ),
                            ElevatedButton(
                              onPressed: () => {
                                Navigator.pop(context),
                                widget.deleteTxFx(
                                    widget.transactions[widget.index].id)
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      ),
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ))
              : TransactionCheckbox(
                  widget.index, widget.changeIsChecked, widget.refreshFx),
        ),
      ),
    );
  }
}
