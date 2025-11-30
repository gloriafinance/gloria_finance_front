/// Model representing the acceptance status of a single policy
class PolicyAcceptanceItem {
  final bool accepted;
  final String? version;
  final DateTime? acceptedAt;

  PolicyAcceptanceItem({
    required this.accepted,
    this.version,
    this.acceptedAt,
  });

  factory PolicyAcceptanceItem.empty() {
    return PolicyAcceptanceItem(accepted: false);
  }

  factory PolicyAcceptanceItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PolicyAcceptanceItem.empty();
    }
    return PolicyAcceptanceItem(
      accepted: json['accepted'] ?? false,
      version: json['version'],
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.tryParse(json['acceptedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accepted': accepted,
      'version': version,
      'acceptedAt': acceptedAt?.toIso8601String(),
    };
  }

  /// Check if policy is accepted with the required version
  bool isAcceptedWithVersion(String requiredVersion) {
    return accepted && version == requiredVersion && acceptedAt != null;
  }
}

/// Model representing the policy acceptance status from backend
class PolicyAcceptanceModel {
  final PolicyAcceptanceItem privacyPolicy;
  final PolicyAcceptanceItem sensitiveDataPolicy;

  PolicyAcceptanceModel({
    required this.privacyPolicy,
    required this.sensitiveDataPolicy,
  });

  factory PolicyAcceptanceModel.empty() {
    return PolicyAcceptanceModel(
      privacyPolicy: PolicyAcceptanceItem.empty(),
      sensitiveDataPolicy: PolicyAcceptanceItem.empty(),
    );
  }

  factory PolicyAcceptanceModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PolicyAcceptanceModel.empty();
    }
    return PolicyAcceptanceModel(
      privacyPolicy: PolicyAcceptanceItem.fromJson(
        json['privacyPolicy'] as Map<String, dynamic>?,
      ),
      sensitiveDataPolicy: PolicyAcceptanceItem.fromJson(
        json['sensitiveDataPolicy'] as Map<String, dynamic>?,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'privacyPolicy': privacyPolicy.toJson(),
      'sensitiveDataPolicy': sensitiveDataPolicy.toJson(),
    };
  }

  /// Check if all policies are accepted with the required versions
  bool areAllPoliciesAccepted({
    required String requiredPrivacyVersion,
    required String requiredSensitiveDataVersion,
  }) {
    return privacyPolicy.isAcceptedWithVersion(requiredPrivacyVersion) &&
        sensitiveDataPolicy.isAcceptedWithVersion(requiredSensitiveDataVersion);
  }
}
