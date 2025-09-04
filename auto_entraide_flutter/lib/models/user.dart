import 'dart:convert';

class User {
  final int id;
  final String email;
  final String name;
  final String? phone;
  final bool isProfessional;
  final String? qualifications;
  final int reputationScore;
  final double referralBalance;
  final DateTime createdAt;
  
  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.isProfessional,
    this.qualifications,
    required this.reputationScore,
    required this.referralBalance,
    required this.createdAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      isProfessional: json['is_professional'] ?? false,
      qualifications: json['qualifications'],
      reputationScore: json['reputation_score'] ?? 0,
      referralBalance: (json['referral_balance'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  factory User.fromJsonString(String jsonString) {
    return User.fromJson(json.decode(jsonString));
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'is_professional': isProfessional,
      'qualifications': qualifications,
      'reputation_score': reputationScore,
      'referral_balance': referralBalance,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  String toJsonString() {
    return json.encode(toJson());
  }
}