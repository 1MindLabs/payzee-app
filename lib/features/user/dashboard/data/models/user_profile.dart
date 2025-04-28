class UserProfile {
  final String userId;
  final int allocatedAmt;
  final int remainingAmt;
  final int personalWallet;
  final int govtWallet;

  UserProfile({
    required this.userId,
    required this.allocatedAmt,
    required this.remainingAmt,
    required this.personalWallet,
    required this.govtWallet,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] as String,
      allocatedAmt: json['allocated_amt'] as int,
      remainingAmt: json['remaining_amt'] as int,
      personalWallet: json['personal_wallet'] as int,
      govtWallet: int.parse(json['govt_wallet'].toString()), // because govt_wallet is coming as a string
    );
  }

  // Method to convert UserProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'allocated_amt': allocatedAmt,
      'remaining_amt': remainingAmt,
      'personal_wallet': personalWallet,
      'govt_wallet': govtWallet,
    };
  }
}
