import 'package:gloria_finance/l10n/app_localizations.dart';

enum MemberContributionType { tithe, offering }

enum MemberPaymentChannel { pix, boleto, externalWithReceipt }

enum MemberContributionStatus { pending, paid, failed, pendingReview }

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
      case MemberPaymentChannel.boleto:
        return l10n.member_contribution_payment_method_boleto_title;
      case MemberPaymentChannel.externalWithReceipt:
        return l10n.member_contribution_payment_method_manual_title;
    }
  }

  String description(AppLocalizations l10n) {
    switch (this) {
      case MemberPaymentChannel.pix:
        return l10n.member_contribution_payment_method_pix_description;
      case MemberPaymentChannel.boleto:
        return l10n.member_contribution_payment_method_boleto_description;
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
  final String destinationId;
  final String? financialConceptId; // For offerings
  final double amount;
  final MemberPaymentChannel channel;
  final String? message;
  final DateTime? paidAt;
  final String? receiptUrl;

  MemberContributionRequest({
    required this.type,
    required this.destinationId,
    this.financialConceptId,
    required this.amount,
    required this.channel,
    this.message,
    this.paidAt,
    this.receiptUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type == MemberContributionType.tithe ? 'TITHE' : 'OFFERING',
      'destinationId': destinationId,
      if (financialConceptId != null) 'financialConceptId': financialConceptId,
      'amount': amount,
      'channel': _channelToString(channel),
      if (message != null && message!.isNotEmpty) 'message': message,
      if (paidAt != null) 'paidAt': paidAt!.toIso8601String(),
      if (receiptUrl != null) 'receiptUrl': receiptUrl,
    };
  }

  String _channelToString(MemberPaymentChannel channel) {
    switch (channel) {
      case MemberPaymentChannel.pix:
        return 'PIX';
      case MemberPaymentChannel.boleto:
        return 'BOLETO';
      case MemberPaymentChannel.externalWithReceipt:
        return 'MANUAL';
    }
  }
}

class PixChargeResponse {
  final String contributionId;
  final String qrCodePayload;
  final String pixCopyPasteCode;
  final DateTime expiration;
  final double amount;
  final String description;

  PixChargeResponse({
    required this.contributionId,
    required this.qrCodePayload,
    required this.pixCopyPasteCode,
    required this.expiration,
    required this.amount,
    required this.description,
  });

  factory PixChargeResponse.fromJson(Map<String, dynamic> json) {
    return PixChargeResponse(
      contributionId: json['contributionId'] ?? json['id'] ?? '',
      qrCodePayload: json['qrCodePayload'] ?? json['pixQrCode'] ?? '',
      pixCopyPasteCode: json['pixCopyPasteCode'] ?? json['pixCode'] ?? '',
      expiration:
          json['expiration'] != null
              ? DateTime.parse(json['expiration'])
              : DateTime.now().add(const Duration(hours: 24)),
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
    );
  }
}

class BoletoChargeResponse {
  final String contributionId;
  final String digitableLine;
  final String boletoPdfUrl;
  final DateTime dueDate;
  final double amount;

  BoletoChargeResponse({
    required this.contributionId,
    required this.digitableLine,
    required this.boletoPdfUrl,
    required this.dueDate,
    required this.amount,
  });

  factory BoletoChargeResponse.fromJson(Map<String, dynamic> json) {
    return BoletoChargeResponse(
      contributionId: json['contributionId'] ?? json['id'] ?? '',
      digitableLine: json['digitableLine'] ?? json['boletoLine'] ?? '',
      boletoPdfUrl: json['boletoPdfUrl'] ?? json['pdfUrl'] ?? '',
      dueDate:
          json['dueDate'] != null
              ? DateTime.parse(json['dueDate'])
              : DateTime.now().add(const Duration(days: 3)),
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}

class ContributionResult {
  final MemberContributionStatus status;
  final MemberPaymentChannel channel;
  final String? contributionId;
  final PixChargeResponse? pixPayload;
  final BoletoChargeResponse? boletoPayload;
  final String? errorMessage;

  ContributionResult({
    required this.status,
    required this.channel,
    this.contributionId,
    this.pixPayload,
    this.boletoPayload,
    this.errorMessage,
  });
}
