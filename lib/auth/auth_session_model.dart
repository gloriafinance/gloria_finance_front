import 'models/policy_acceptance_model.dart';
import 'models/policy_config.dart';

class AuthSessionModel {
  final String token;
  final String name;
  final String email;
  final String createdAt;
  final bool isActive;
  final String userId;
  final String churchId;
  final List<String> roles;
  String? memberId;
  PolicyAcceptanceModel policies;

  AuthSessionModel({
    required this.churchId,
    required this.token,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.isActive,
    required this.userId,
    required this.roles,
    this.memberId,
    PolicyAcceptanceModel? policies,
  }) : policies = policies ?? PolicyAcceptanceModel.empty();

  factory AuthSessionModel.empty() {
    return AuthSessionModel(
      token: "",
      name: "",
      email: "",
      createdAt: "",
      isActive: false,
      userId: "",
      churchId: '',
      roles: [],
      policies: PolicyAcceptanceModel.empty(),
    );
  }

  AuthSessionModel copyWith({
    String? token,
    String? churchId,
    String? name,
    String? email,
    String? createdAt,
    bool? isActive,
    String? userId,
    String? memberId,
    List<String>? roles,
    PolicyAcceptanceModel? policies,
  }) {
    return AuthSessionModel(
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      name: name ?? this.name,
      email: email ?? this.email,
      churchId: churchId ?? this.churchId,
      memberId: memberId ?? this.memberId,
      roles: roles ?? this.roles,
      policies: policies ?? this.policies,
    );
  }

  static AuthSessionModel fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
      token: json['token'],
      name: json['name'],
      email: json['email'],
      createdAt: json['createdAt'],
      isActive: json['isActive'],
      userId: json['userId'],
      churchId: json['churchId'],
      memberId: json['memberId'],
      policies: PolicyAcceptanceModel.fromJson(
        json['policies'] as Map<String, dynamic>?,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roles': roles,
      'token': token,
      'name': name,
      'email': email,
      'createdAt': createdAt,
      'isActive': isActive,
      'userId': userId,
      'churchId': churchId,
      'memberId': memberId,
      'policies': policies.toJson(),
    };
  }

  bool isSessionStarted() {
    return token != "";
  }

  String getName() {
    return name;
  }

  isAdmin() {
    return roles.contains('ADMIN');
  }

  isMember() {
    return roles.contains('MEMBER');
  }

  isTreasurer() {
    return roles.contains('TREASURER');
  }

  isPastor() {
    return roles.contains('PASTOR');
  }

  /// Check if the user needs to accept policies before using the app
  bool needsPolicyAcceptance() {
    return !policies.areAllPoliciesAccepted(
      requiredPrivacyVersion: PolicyConfig.privacyPolicyVersion,
      requiredSensitiveDataVersion: PolicyConfig.sensitiveDataPolicyVersion,
    );
  }
}
