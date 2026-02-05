import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';

import '../models/contribution_model.dart';

Color getContributionStatusColor(ContributionStatus status) {
  switch (status) {
    case ContributionStatus.PROCESSED:
      return Colors.green;
    case ContributionStatus.PENDING_VERIFICATION:
      return Colors.orange;
    case ContributionStatus.REJECTED:
      return Colors.red;
  }
}

String getContributionStatusLabel(
  BuildContext context,
  ContributionStatus status,
) {
  final l10n = context.l10n;
  switch (status) {
    case ContributionStatus.PROCESSED:
      return l10n.contributions_status_processed;
    case ContributionStatus.PENDING_VERIFICATION:
      return l10n.contributions_status_pending_verification;
    case ContributionStatus.REJECTED:
      return l10n.contributions_status_rejected;
  }
}

ContributionStatus parseContributionStatus(dynamic status) {
  if (status is ContributionStatus) {
    return status;
  }

  final normalized = status?.toString().toUpperCase();
  switch (normalized) {
    case "PROCESSED":
    case "PROCESSADA":
      return ContributionStatus.PROCESSED;
    case "PENDING_VERIFICATION":
    case "VERIFICAÇÃO PENDENTE":
      return ContributionStatus.PENDING_VERIFICATION;
    case "REJECTED":
    case "REJEITADA":
      return ContributionStatus.REJECTED;
    default:
      return ContributionStatus.PENDING_VERIFICATION;
  }
}
