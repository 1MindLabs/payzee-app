class PastTransaction {
  final DateTime date;
  final String merchant, utility;
  final double amount;
  PastTransaction({
    required this.date,
    required this.merchant,
    required this.amount,
    required this.utility,
  });
}
