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
  final String churchName;
  final List<String> roles;
  final String? memberId;
  final String lang;
  final String? lastLogin;
  final bool isSuperUser;
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
    this.churchName = '',
    this.lang = 'pt-BR',
    this.memberId,
    this.lastLogin,
    this.isSuperUser = false,
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
      churchName: '',
      lang: 'pt-BR',
      roles: [],
      policies: PolicyAcceptanceModel.empty(),
    );
  }

  AuthSessionModel copyWith({
    String? token,
    String? churchId,
    String? churchName,
    String? name,
    String? email,
    String? createdAt,
    bool? isActive,
    String? userId,
    String? memberId,
    String? lang,
    String? lastLogin,
    bool? isSuperUser,
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
      churchName: churchName ?? this.churchName,
      memberId: memberId ?? this.memberId,
      lang: lang ?? this.lang,
      lastLogin: lastLogin ?? this.lastLogin,
      isSuperUser: isSuperUser ?? this.isSuperUser,
      roles: roles ?? this.roles,
      policies: policies ?? this.policies,
    );
  }

  static AuthSessionModel fromJson(Map<String, dynamic> json) {
    String churchId = '';
    String churchName = '';
    String lang = 'pt-BR';

    if (json['church'] != null && json['church'] is Map) {
      churchId = json['church']['churchId'] ?? '';
      churchName = json['church']['name'] ?? '';
      lang = json['church']['lang'] ?? 'pt-BR';
    } else if (json['churchId'] != null) {
      // Fallback for flat structure if needed, or legacy
      churchId = json['churchId'];
    }

    return AuthSessionModel(
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
      token: json['token'],
      name: json['name'],
      email: json['email'],
      createdAt: json['createdAt'],
      isActive: json['isActive'],
      userId: json['userId'],
      churchId: churchId,
      churchName: churchName,
      memberId: json['memberId'],
      lang: lang,
      lastLogin: json['lastLogin'],
      isSuperUser: json['isSuperUser'] ?? false,
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
      'church': {'churchId': churchId, 'name': churchName, 'lang': lang},
      'memberId': memberId,
      'lastLogin': lastLogin,
      'isSuperUser': isSuperUser,
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
