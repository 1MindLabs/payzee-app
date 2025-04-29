import 'package:upi_pay/features/user/dashboard/data/models/past_transaction.dart';

class UserProfile {
  final String userId;
  final int allocatedAmt;
  final int remainingAmt;
  final int personalWallet;
  final int govtWallet;
  final String password;
  final AccountInfo accountInfo;
  final List<PastTransaction> pastTransactions;

  UserProfile({
    required this.userId,
    required this.allocatedAmt,
    required this.remainingAmt,
    required this.personalWallet,
    required this.govtWallet,
    required this.password,
    required this.accountInfo,
    required this.pastTransactions,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['id'] as String,
      allocatedAmt: json['allocated_amt'] as int,
      remainingAmt: json['remaining_amt'] as int,
      personalWallet: json['personal_wallet'] as int,
      govtWallet: int.parse(json['govt_wallet'].toString()), // safely handle string/int cases
      password: json['password'] as String,
      accountInfo: AccountInfo.fromJson(json['account_info']),
      pastTransactions: (json['past_transactions'] as List<dynamic>)
          .map((tx) => PastTransaction.fromJson(tx))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'allocated_amt': allocatedAmt,
      'remaining_amt': remainingAmt,
      'personal_wallet': personalWallet,
      'govt_wallet': govtWallet,
      'password': password,
      'account_info': accountInfo.toJson(),
      'past_transactions': pastTransactions.map((tx) => tx.toJson()).toList(),
    };
  }
}

class AccountInfo {
  final String phoneNumber;
  final String dateCreated;
  final String address;
  final String email;
  final String fullName;
  final String username;
  final String aadhaarNumber;

  AccountInfo({
    required this.phoneNumber,
    required this.dateCreated,
    required this.address,
    required this.email,
    required this.fullName,
    required this.username,
    required this.aadhaarNumber,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      phoneNumber: json['phone_number'] as String,
      dateCreated: json['date_created'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      username: json['username'] as String,
      aadhaarNumber: json['aadhaar_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'date_created': dateCreated,
      'address': address,
      'email': email,
      'full_name': fullName,
      'username': username,
      'aadhaar_number': aadhaarNumber,
    };
  }
}

