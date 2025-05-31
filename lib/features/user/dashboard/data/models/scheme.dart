class SchemeModel {
  final String id;
  final String name;
  final String description;
  final double amount;
  final String? govtId;
  final EligibilityCriteria eligibilityCriteria;
  final EligibilityCheck? eligibilityCheck;
  final bool eligible;
  final bool? alreadyEnrolled;

  SchemeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    this.govtId,
    required this.eligibilityCriteria,
    this.eligibilityCheck,
    required this.eligible,
    this.alreadyEnrolled,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      govtId: json['govt_id'] as String?,
      eligibilityCriteria: EligibilityCriteria.fromJson(
        json['eligibility_criteria'] as Map<String, dynamic>,
      ),
      eligibilityCheck: json['eligibility_check'] != null
          ? EligibilityCheck.fromJson(json['eligibility_check'] as Map<String, dynamic>)
          : null,
      eligible: json['eligible'] as bool,
      alreadyEnrolled: json['already_enrolled'] as bool?,
    );
  }
}

class EligibilityCriteria {
  final String occupation;
  final int minAge;
  final int maxAge;
  final String gender;
  final String state;
  final String district;
  final String city;
  final String caste;
  final int annualIncome;

  EligibilityCriteria({
    required this.occupation,
    required this.minAge,
    required this.maxAge,
    required this.gender,
    required this.state,
    required this.district,
    required this.city,
    required this.caste,
    required this.annualIncome,
  });

  factory EligibilityCriteria.fromJson(Map<String, dynamic> json) {
    return EligibilityCriteria(
      occupation: json['occupation'] as String,
      minAge: json['min_age'] as int,
      maxAge: json['max_age'] as int,
      gender: json['gender'] as String,
      state: json['state'] as String,
      district: json['district'] as String,
      city: json['city'] as String,
      caste: json['caste'] as String,
      annualIncome: json['annual_income'] as int,
    );
  }
}

class EligibilityCheck {
  final EligibilityCheckItem occupation;
  final EligibilityCheckItem gender;
  final EligibilityCheckItem caste;
  final EligibilityCheckItem annualIncome;
  final EligibilityCheckItem age;
  final EligibilityCheckItem state;
  final EligibilityCheckItem district;
  final EligibilityCheckItem city;

  EligibilityCheck({
    required this.occupation,
    required this.gender,
    required this.caste,
    required this.annualIncome,
    required this.age,
    required this.state,
    required this.district,
    required this.city,
  });

  factory EligibilityCheck.fromJson(Map<String, dynamic> json) {
    return EligibilityCheck(
      occupation: EligibilityCheckItem.fromJson(json['occupation'] as Map<String, dynamic>),
      gender: EligibilityCheckItem.fromJson(json['gender'] as Map<String, dynamic>),
      caste: EligibilityCheckItem.fromJson(json['caste'] as Map<String, dynamic>),
      annualIncome: EligibilityCheckItem.fromJson(json['annual_income'] as Map<String, dynamic>),
      age: EligibilityCheckItem.fromJson(json['age'] as Map<String, dynamic>),
      state: EligibilityCheckItem.fromJson(json['state'] as Map<String, dynamic>),
      district: EligibilityCheckItem.fromJson(json['district'] as Map<String, dynamic>),
      city: EligibilityCheckItem.fromJson(json['city'] as Map<String, dynamic>),
    );
  }
}

class EligibilityCheckItem {
  final String required;
  final dynamic actual;
  final bool passed;

  EligibilityCheckItem({
    required this.required,
    required this.actual,
    required this.passed,
  });

  factory EligibilityCheckItem.fromJson(Map<String, dynamic> json) {
    return EligibilityCheckItem(
      required: json['required'],
      actual: json['actual'],
      passed: json['passed'] as bool,
    );
  }
}