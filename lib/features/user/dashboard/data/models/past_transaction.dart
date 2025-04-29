class PastTransaction {
  final String shopName;
  final String date;
  final String timestamp;
  final int amount;
  final String category;

  PastTransaction({
    required this.shopName,
    required this.date,
    required this.timestamp,
    required this.amount,
    required this.category,
  });

  factory PastTransaction.fromJson(Map<String, dynamic> json) {
    return PastTransaction(
      shopName: json['shop_name'] as String,
      date: json['date'] as String,
      timestamp: json['timestamp'] as String,
      amount: json['amount'] as int,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shop_name': shopName,
      'date': date,
      'timestamp': timestamp,
      'amount': amount,
      'category': category,
    };
  }
}
