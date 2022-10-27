import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

import './models/transaction.dart';
import './widgets/new_transactions.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      description: 'Example 1: American Eagle',
      amount: 139.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      description: 'Example 2: Chick Fil A',
      amount: 23.47,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't3',
      description: 'Example 3: Rent',
      amount: 780,
      date: DateTime.now().subtract(Duration(days: 6)),
    ),
  ];

  var _uuid = Uuid();
  var _transactionEditorEnabled = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: Wrap(
              children: [
                NewTransaction(_addNewTransaction),
              ],
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _addNewTransaction(
      String description, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: _uuid.v4(),
      description: description,
      amount: amount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _deleteCheckedTransactions() {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.isChecked == true);
    });
  }

  void _clearTransactions() {
    setState(() {
      _userTransactions.clear();
    });
  }

  void _editTransactions() {
    setState(() {
      _transactionEditorEnabled = true;
    });
  }

  void _resetIsChecked() {
    setState(() {
      _userTransactions.forEach((element) => element.isChecked = false);
    });
  }

  void _resetFloatingButtonState() {
    setState(() => null);
  }

  Widget _buildEditingFloatingActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (_recentTransactions.any((element) => element.isChecked == true))
          FloatingActionButton(
            child: const Icon(Icons.delete),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text(
                    'Attention!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                      'Are you sure you want to clear all selected transactions? \n\n(This action cannot be undone)'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        _resetIsChecked();
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.pop(context),
                        _deleteCheckedTransactions(),
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
              _transactionEditorEnabled = false;
            },
          ),
        FloatingActionButton(
          child: const Icon(Icons.cancel),
          onPressed: () => setState(
            () {
              _resetIsChecked();
              _transactionEditorEnabled = false;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildClearAllIconButton() {
    return IconButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            'WARNING!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
              'Are you sure you want to clear ALL transactions? \n\n(This action cannot be undone)'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => {Navigator.pop(context), _clearTransactions()},
              child: const Text('Yes'),
            ),
          ],
        ),
      ),
      icon: Icon(Icons.delete_forever),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Expenses'),
        actions: [
          if (_transactionEditorEnabled == false)
            IconButton(
              onPressed: () => _startAddNewTransaction(context),
              icon: const Icon(Icons.add),
            ),
          if (_transactionEditorEnabled == false &&
              _userTransactions.length >= 1)
            IconButton(
              onPressed: () {
                _editTransactions();
              },
              icon: const Icon(Icons.edit),
            ),
          if (_transactionEditorEnabled == false &&
              _userTransactions.length >= 1)
            _buildClearAllIconButton(),
          if (_transactionEditorEnabled == true)
            TextButton(
              onPressed: () => setState(() {
                _resetIsChecked();
                _transactionEditorEnabled = false;
              }),
              child: const Text('Cancel',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            )
        ],
      ),
      body: Column(
        children: [
          Container(
              height: mediaQuery.size.height > 750
                  ? mediaQuery.size.height * 0.18
                  : mediaQuery.size.height * 0.23,
              child: Chart(_recentTransactions)),
          Expanded(
            child: TransactionList(_userTransactions, _deleteTransaction,
                _transactionEditorEnabled, _resetFloatingButtonState),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _transactionEditorEnabled == false
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            )
          : _buildEditingFloatingActionButtons(),
    );
  }
}
