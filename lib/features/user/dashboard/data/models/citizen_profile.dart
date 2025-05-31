class CitizenProfile {
  final AccountInfo accountInfo;
  final PersonalInfo personalInfo;
  final WalletInfo walletInfo;
  final List<String>? schemes;

  CitizenProfile({
    required this.accountInfo,
    required this.personalInfo,
    required this.walletInfo,
    this.schemes,
  });

  factory CitizenProfile.fromJson(Map<String, dynamic> json) {
    return CitizenProfile(
      accountInfo: AccountInfo.fromJson(json['account_info']),
      personalInfo: PersonalInfo.fromJson(json['personal_info']),
      walletInfo: WalletInfo.fromJson(json['wallet_info']),
      schemes: json['scheme_id'] != null
          ? List<String>.from(json['scheme_id'])
          : null,
    );
  }

  factory CitizenProfile.empty() {
    return CitizenProfile(
      accountInfo: AccountInfo.empty(),
      personalInfo: PersonalInfo.empty(),
      walletInfo: WalletInfo.empty(),
      schemes: null,
    );
  }
}

class AccountInfo {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userType;
  final String imageUrl;

  AccountInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.userType,
    required this.imageUrl,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      userType: json['user_type'],
      imageUrl: json['image_url'],
    );
  }

  factory AccountInfo.empty() {
    return AccountInfo(
      id: '',
      name: '',
      email: '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      userType: '',
      imageUrl: '',
    );
  }
}

class PersonalInfo {
  final String phone;
  final String address;
  final String idType;
  final String idNumber;
  final String dob;
  final String gender;
  final String occupation;
  final String caste;
  final int annualIncome;

  PersonalInfo({
    required this.phone,
    required this.address,
    required this.idType,
    required this.idNumber,
    required this.dob,
    required this.gender,
    required this.occupation,
    required this.caste,
    required this.annualIncome,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      phone: json['phone'],
      address: json['address'],
      idType: json['id_type'],
      idNumber: json['id_number'],
      dob: json['dob'],
      gender: json['gender'],
      occupation: json['occupation'],
      caste: json['caste'],
      annualIncome: json['annual_income'],
    );
  }

  factory PersonalInfo.empty() {
    return PersonalInfo(
      phone: '',
      address: '',
      idType: '',
      idNumber: '',
      dob: '',
      gender: '',
      occupation: '',
      caste: '',
      annualIncome: 0,
    );
  }
}

class WalletInfo {
  final Wallet govtWallet;
  final Wallet personalWallet;

  WalletInfo({required this.govtWallet, required this.personalWallet});

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      govtWallet: Wallet.fromJson(json['govt_wallet']),
      personalWallet: Wallet.fromJson(json['personal_wallet']),
    );
  }

  factory WalletInfo.empty() {
    return WalletInfo(
      govtWallet: Wallet.empty(),
      personalWallet: Wallet.empty(),
    );
  }
}

class Wallet {
  final int balance;
  final List<String> transactions;

  Wallet({required this.balance, required this.transactions});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: json['balance'],
      transactions: List<String>.from(json['transactions']),
    );
  }

  factory Wallet.empty() {
    return Wallet(
      balance: 0,
      transactions: [],
    );
  }
}
