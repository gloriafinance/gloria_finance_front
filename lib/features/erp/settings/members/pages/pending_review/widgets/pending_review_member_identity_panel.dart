import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../../models/member_model.dart';
import 'pending_review_member_detail_support.dart';

class PendingReviewMemberIdentityPanel extends StatelessWidget {
  final MemberModel member;
  final bool mobile;

  const PendingReviewMemberIdentityPanel({
    super.key,
    required this.member,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final photoUrl = pendingReviewPhotoUrl(member);
    final photoSize = mobile ? 140.0 : 190.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment:
            mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: photoSize,
              height: photoSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.greyLight,
              ),
              clipBehavior: Clip.antiAlias,
              child:
                  photoUrl != null
                      ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, _, _) => _photoPlaceholder(photoSize, l10n),
                      )
                      : _photoPlaceholder(photoSize, l10n),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            member.name,
            textAlign: mobile ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          _identityLine(member.phone, Icons.phone_outlined),
          if (member.email.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _identityLine(member.email, Icons.mail_outline),
          ],
          const SizedBox(height: 18),
          Align(
            alignment: mobile ? Alignment.center : Alignment.centerLeft,
            child: pendingReviewStatusBadge(
              label: l10n.member_list_status_pending_review,
              background: const Color(0xFFFFF1D6),
              foreground: const Color(0xFF9A6700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder(double size, AppLocalizations l10n) {
    return Container(
      color: AppColors.greyLight,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: size * 0.34, color: Colors.black45),
          const SizedBox(height: 10),
          Text(
            l10n.member_pending_review_photo_unavailable,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: mobile ? 12 : 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _identityLine(String value, IconData icon) {
    return Row(
      mainAxisAlignment:
          mobile ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.grey),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: mobile ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
