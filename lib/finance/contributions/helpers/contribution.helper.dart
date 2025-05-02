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

ContributionStatus parseContributionStatus(String status) {
  switch (status) {
    case "PROCESSED":
      return ContributionStatus.PROCESSED;
    case "PENDING_VERIFICATION":
      return ContributionStatus.PENDING_VERIFICATION;
    case "REJECTED":
      return ContributionStatus.REJECTED;
    default:
      throw ArgumentError("Unknown status: $status");
  }
}
