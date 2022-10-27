class Transaction {
  Transaction(
      {required this.id,
      required this.description,
      required this.amount,
      required this.date,
      this.isChecked = false});
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  var isChecked;
}
