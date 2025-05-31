class CitizenResponse {
  final String messagestring;
  final String? userId;
  final String? userType;
  final String? transactionId;
  final String? schemeId;
  final int? beneficiariesCount;

  CitizenResponse({
    required this.messagestring,
    this.userId,
    this.userType,
    this.transactionId,
    this.schemeId,
    this.beneficiariesCount,
  });

  factory CitizenResponse.fromJson(Map<String, dynamic> json) {
    return CitizenResponse(
      messagestring: json['messagestring'] ?? '',
      userId: json['user_id'],
      userType: json['user_type'],
      transactionId: json['transaction_id'],
      schemeId: json['scheme_id'],
      beneficiariesCount: json['beneficiaries_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messagestring': messagestring,
      'user_id': userId,
      'user_type': userType,
      'transaction_id': transactionId,
      'scheme_id': schemeId,
      'beneficiaries_count': beneficiariesCount,
    };
  }
}
