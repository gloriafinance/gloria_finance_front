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
  final String country;
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
    this.country = '',
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
      country: '',
      lang: 'pt-BR',
      roles: [],
      policies: PolicyAcceptanceModel.empty(),
    );
  }

  AuthSessionModel copyWith({
    String? token,
    String? churchId,
    String? churchName,
    String? country,
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
      country: country ?? this.country,
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
    String country = '';
    String lang = 'pt-BR';
    String? memberId;

    if (json['church'] != null && json['church'] is Map) {
      churchId = json['church']['churchId'] ?? '';
      churchName = json['church']['name'] ?? '';
      country = json['church']['country'] ?? '';
      lang = json['church']['lang'] ?? 'pt-BR';
    } else if (json['churchId'] != null) {
      // Fallback for flat structure if needed, or legacy
      churchId = json['churchId'];
    }

    final dynamic memberRoot = json['member'];
    memberId =
        (json['memberId'] ??
                json['member_id'] ??
                (memberRoot is Map
                    ? (memberRoot['memberId'] ??
                        memberRoot['member_id'] ??
                        memberRoot['id'] ??
                        memberRoot['_id'])
                    : null))
            ?.toString();
    if (memberId != null && memberId.trim().isEmpty) {
      memberId = null;
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
      country: country,
      memberId: memberId,
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
      'church': {
        'churchId': churchId,
        'name': churchName,
        'lang': lang,
        'country': country,
      },
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
