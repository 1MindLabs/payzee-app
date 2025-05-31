class CitizenTransaction {
  final String id;
  final String fromId;
  final String toId;
  final int amount;
  final String txType;
  final String? schemeId;
  final String description;
  final DateTime timestamp;
  final String status;

  CitizenTransaction({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.amount,
    required this.txType,
    this.schemeId,
    required this.description,
    required this.timestamp,
    required this.status,
  });

  factory CitizenTransaction.fromJson(Map<String, dynamic> json) {
    return CitizenTransaction(
      id: json['id'],
      fromId: json['from_id'],
      toId: json['to_id'],
      amount: json['amount'],
      txType: json['tx_type'],
      schemeId: json['scheme_id'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_id': fromId,
      'to_id': toId,
      'amount': amount,
      'tx_type': txType,
      'scheme_id': schemeId,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}
