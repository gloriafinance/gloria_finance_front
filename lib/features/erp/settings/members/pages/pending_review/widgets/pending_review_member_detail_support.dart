import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../../models/member_model.dart';

class PendingReviewInfoItem {
  final String label;
  final String value;
  final bool fullWidth;
  final Widget? badge;

  const PendingReviewInfoItem({
    required this.label,
    required this.value,
    this.fullWidth = false,
    this.badge,
  });
}

String pendingReviewFormatDate(AppLocalizations l10n, String? value) {
  if (value == null || value.isEmpty) {
    return l10n.member_pending_review_not_informed;
  }

  // MemberModel normalizes birthdate/conversionDate/baptismDate to
  // dd/MM/yyyy. Return as-is to avoid re-parsing the already-formatted
  // string.
  if (value.length == 10 && value[2] == '/' && value[5] == '/') {
    return value;
  }

  // Other timestamps (createdAt, lgpdConsent.acceptedAt) come as ISO 8601.
  final parsed = parseIsoDate(value);
  if (parsed == null) {
    return l10n.member_pending_review_not_informed;
  }
  return formatDateToDDMMYYYY(parsed.toLocal());
}

String pendingReviewOrNotInformed(AppLocalizations l10n, String? value) {
  if (value == null || value.trim().isEmpty) {
    return l10n.member_pending_review_not_informed;
  }
  return value;
}

String pendingReviewAddressValue(AppLocalizations l10n, String? value) {
  if (value == null || value.trim().isEmpty) {
    return l10n.member_pending_review_not_informed;
  }
  return value;
}

String pendingReviewLgpdLabel(AppLocalizations l10n, MemberModel member) {
  final accepted = member.lgpdConsent?.accepted ?? false;
  return accepted
      ? l10n.member_pending_review_lgpd_yes
      : l10n.member_pending_review_lgpd_no;
}

String? pendingReviewPhotoUrl(MemberModel member) {
  final value = member.profilePhoto;
  if (value == null || value.isEmpty) {
    return null;
  }

  final uri = Uri.tryParse(value);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    return null;
  }

  return value;
}

Widget pendingReviewStatusBadge({
  required String label,
  required Color background,
  required Color foreground,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 12,
        color: foreground,
      ),
    ),
  );
}

Widget pendingReviewSectionCard({
  required String title,
  required Widget child,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFFAFAFB),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 18,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

Widget pendingReviewInfoGrid({
  required bool mobile,
  required List<PendingReviewInfoItem> items,
}) {
  if (mobile) {
    return Column(
      children:
          items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: pendingReviewInfoTile(item),
                ),
              )
              .toList(),
    );
  }

  final rows = <Widget>[];
  for (var i = 0; i < items.length; i += 2) {
    final left = items[i];
    final right = i + 1 < items.length ? items[i + 1] : null;

    if (left.fullWidth) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: pendingReviewInfoTile(left),
        ),
      );
      continue;
    }

    if (right != null && right.fullWidth) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Expanded(child: pendingReviewInfoTile(left))],
          ),
        ),
      );
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: pendingReviewInfoTile(right),
        ),
      );
      continue;
    }

    rows.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: pendingReviewInfoTile(left)),
            const SizedBox(width: 16),
            Expanded(
              child:
                  right != null
                      ? pendingReviewInfoTile(right)
                      : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  return Column(children: rows);
}

Widget pendingReviewInfoTile(PendingReviewInfoItem item) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        item.label,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 12,
          color: AppColors.grey,
        ),
      ),
      const SizedBox(height: 6),
      item.badge ??
          Text(
            item.value,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 15,
              color: AppColors.black,
            ),
          ),
    ],
  );
}
