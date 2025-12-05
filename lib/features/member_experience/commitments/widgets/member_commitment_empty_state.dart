import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';

class MemberCommitmentEmptyState extends StatelessWidget {
  const MemberCommitmentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'images/contribution.png',
            width: 180,
            height: 180,
            color: AppColors.purple.withAlpha(150),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.member_commitments_empty_title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.member_commitments_empty_subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
