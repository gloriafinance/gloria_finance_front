import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

import 'pending_review_member_detail_support.dart';

class PendingReviewMemberDetailHeader extends StatelessWidget {
  final bool mobile;

  const PendingReviewMemberDetailHeader({super.key, required this.mobile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            InkWell(
              onTap: () => context.go('/members/pending-review'),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.greyMiddle),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: AppColors.purple,
                ),
              ),
            ),
            Text(
              l10n.member_pending_review_detail_title,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: mobile ? 26 : 30,
                color: AppColors.black,
              ),
            ),
            pendingReviewStatusBadge(
              label: l10n.member_list_status_pending_review,
              background: const Color(0xFFFFF1D6),
              foreground: const Color(0xFF9A6700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          l10n.member_pending_review_detail_subtitle,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 15,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
