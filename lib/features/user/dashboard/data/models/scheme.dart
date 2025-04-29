import 'dart:convert';

class SchemeModel {
  final String id;
  final String schemeId;
  final String schemeName;
  final String description;
  final List<String> tags;
  final String status;
  final EligibilityCriteria eligibilityCriteria;
  final double amount;
  final DateTime createdAt;

  SchemeModel({
    required this.id,
    required this.schemeId,
    required this.schemeName,
    required this.description,
    required this.tags,
    required this.status,
    required this.eligibilityCriteria,
    required this.amount,
    required this.createdAt,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      id: json['id'] as String,
      schemeId: json['scheme_id'] as String,
      schemeName: json['scheme_name'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] as List),
      status: json['status'] as String,
      eligibilityCriteria: EligibilityCriteria.fromJson(
        json['eligibility_criteria'] as Map<String, dynamic>,
      ),
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class EligibilityCriteria {
  final String? district;
  final String? dateOfBirth;
  final String? caste;
  final String? city;
  final String? gender;
  final String? state;

  EligibilityCriteria({
    this.district,
    this.dateOfBirth,
    this.caste,
    this.city,
    this.gender,
    this.state,
  });

  factory EligibilityCriteria.fromJson(Map<String, dynamic> json) {
    return EligibilityCriteria(
      district: json['district'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      caste: json['caste'] as String?,
      city: json['city'] as String?,
      gender: json['gender'] as String?,
      state: json['state'] as String?,
    );
  }
}


/// lib/features/user/dashboard/data/providers/scheme_provider.dart
