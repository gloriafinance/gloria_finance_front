import 'package:gloria_finance/l10n/app_localizations.dart';

enum MemberContributionType { tithe, offering }

enum MemberPaymentChannel { pix, externalWithReceipt }

extension MemberContributionTypeExtension on MemberContributionType {
  String label(AppLocalizations l10n) {
    switch (this) {
      case MemberContributionType.tithe:
        return l10n.member_contribution_type_tithe;
      case MemberContributionType.offering:
        return l10n.member_contribution_type_offering;
    }
  }

  String get apiValue {
    switch (this) {
      case MemberContributionType.tithe:
        return 'TITHE';
      case MemberContributionType.offering:
        return 'OFFERING';
    }
  }
}

extension MemberPaymentChannelExtension on MemberPaymentChannel {
  String label(AppLocalizations l10n) {
    switch (this) {
      case MemberPaymentChannel.pix:
        return 'PIX';
      case MemberPaymentChannel.externalWithReceipt:
        return l10n.member_contribution_payment_method_manual_title;
    }
  }

  String description(AppLocalizations l10n) {
    switch (this) {
      case MemberPaymentChannel.pix:
        return l10n.member_contribution_payment_method_pix_description;
      case MemberPaymentChannel.externalWithReceipt:
        return l10n.member_contribution_payment_method_manual_description;
    }
  }
}

class ContributionDestination {
  final String id;
  final String name;
  final String description;

  ContributionDestination({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ContributionDestination.fromJson(Map<String, dynamic> json) {
    return ContributionDestination(
      id: json['id'] ?? json['accountId'] ?? json['campaignId'] ?? '',
      name: json['name'] ?? json['accountName'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class MemberContributionRequest {
  final MemberContributionType type;
  final String? destinationId;
  final String? financialConceptId;
  final double amount;
  final MemberPaymentChannel channel;
  final String? message;
  final DateTime? paidAt;
  final String? receiptUrl;

  MemberContributionRequest({
    required this.type,
    this.destinationId,
    this.financialConceptId,
    required this.amount,
    required this.channel,
    this.message,
    this.paidAt,
    this.receiptUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.apiValue,
      if (destinationId != null) 'destinationId': destinationId,
      if (financialConceptId != null) 'financialConceptId': financialConceptId,
      'amount': amount,
      'channel': channel == MemberPaymentChannel.pix ? 'PIX' : 'MANUAL',
      if (message != null && message!.isNotEmpty) 'message': message,
      if (paidAt != null) 'paidAt': paidAt!.toIso8601String(),
      if (receiptUrl != null) 'receiptUrl': receiptUrl,
    };
  }
}
