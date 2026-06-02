import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

class PendingReviewMemberDetailActions extends StatelessWidget {
  final bool mobile;
  final bool saving;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PendingReviewMemberDetailActions({
    super.key,
    required this.mobile,
    required this.saving,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (saving) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _rejectButton(l10n),
          const SizedBox(height: 12),
          _approveButton(l10n),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(width: 220, child: _rejectButton(l10n)),
        const SizedBox(width: 12),
        SizedBox(width: 220, child: _approveButton(l10n)),
      ],
    );
  }

  Widget _approveButton(AppLocalizations l10n) {
    return CustomButton(
      text: l10n.member_pending_review_action_approve,
      backgroundColor: AppColors.green,
      textColor: Colors.white,
      icon: Icons.check,
      onPressed: onApprove,
    );
  }

  Widget _rejectButton(AppLocalizations l10n) {
    return CustomButton(
      text: l10n.member_pending_review_action_reject,
      backgroundColor: Colors.red,
      textColor: Colors.red,
      typeButton: CustomButton.outline,
      icon: Icons.delete_outline,
      onPressed: onReject,
    );
  }
}
