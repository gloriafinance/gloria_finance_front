import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/index.dart';

import '../../models/member_model.dart';
import '../../models/member_status.dart';

class MemberDetailInfoItem {
  final String label;
  final String value;
  final bool fullWidth;
  final Widget? badge;

  const MemberDetailInfoItem({
    required this.label,
    required this.value,
    this.fullWidth = false,
    this.badge,
  });
}

class MemberDetailLabels {
  final String personalInfoTitle;
  final String addressTitle;
  final String registrationTitle;
  final String lgpdTitle;
  final String notInformedLabel;
  final String photoUnavailableLabel;
  final String nameLabel;
  final String phoneLabel;
  final String emailLabel;
  final String dniLabel;
  final String birthdateLabel;
  final String genderLabel;
  final String conversionDateLabel;
  final String baptismDateLabel;
  final String createdAtLabel;
  final String churchLabel;
  final String statusLabel;
  final String addressFieldLabel;
  final String lgpdYesLabel;
  final String lgpdNoLabel;
  final String lgpdNotInformedLabel;
  final String lgpdSourceLabel;
  final String Function(String date) lgpdAcceptedMessage;

  const MemberDetailLabels({
    required this.personalInfoTitle,
    required this.addressTitle,
    required this.registrationTitle,
    required this.lgpdTitle,
    required this.notInformedLabel,
    required this.photoUnavailableLabel,
    required this.nameLabel,
    required this.phoneLabel,
    required this.emailLabel,
    required this.dniLabel,
    required this.birthdateLabel,
    required this.genderLabel,
    required this.conversionDateLabel,
    required this.baptismDateLabel,
    required this.createdAtLabel,
    required this.churchLabel,
    required this.statusLabel,
    required this.addressFieldLabel,
    required this.lgpdYesLabel,
    required this.lgpdNoLabel,
    required this.lgpdNotInformedLabel,
    required this.lgpdSourceLabel,
    required this.lgpdAcceptedMessage,
  });
}

String memberDetailFormatDate(String notInformedLabel, String? value) {
  final parsed = parseIsoDate(value);
  if (parsed == null) {
    return notInformedLabel;
  }
  return formatDateToDDMMYYYY(parsed.toLocal());
}

String memberDetailOrNotInformed(String notInformedLabel, String? value) {
  if (value == null || value.trim().isEmpty) {
    return notInformedLabel;
  }
  return value;
}

String? memberDetailPhotoUrl(MemberModel member) {
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

Widget memberDetailStatusBadge({
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

Widget memberStatusBadgeFor({
  required MemberStatus status,
  required String activeLabel,
  required String inactiveLabel,
  required String pendingReviewLabel,
}) {
  return switch (status) {
    MemberStatus.approved => memberDetailStatusBadge(
      label: activeLabel,
      background: const Color(0xFFE8F8EF),
      foreground: const Color(0xFF0D7A43),
    ),
    MemberStatus.inactive => memberDetailStatusBadge(
      label: inactiveLabel,
      background: const Color(0xFFFEECEC),
      foreground: const Color(0xFFB42318),
    ),
    MemberStatus.pendingReview => memberDetailStatusBadge(
      label: pendingReviewLabel,
      background: const Color(0xFFFFF1D6),
      foreground: const Color(0xFF9A6700),
    ),
  };
}

Widget memberDetailSectionCard({required String title, required Widget child}) {
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

Widget memberDetailInfoGrid({
  required bool mobile,
  required List<MemberDetailInfoItem> items,
}) {
  if (mobile) {
    return Column(
      children:
          items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: memberDetailInfoTile(item),
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
          child: memberDetailInfoTile(left),
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
            children: [Expanded(child: memberDetailInfoTile(left))],
          ),
        ),
      );
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: memberDetailInfoTile(right),
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
            Expanded(child: memberDetailInfoTile(left)),
            const SizedBox(width: 16),
            Expanded(
              child:
                  right != null
                      ? memberDetailInfoTile(right)
                      : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  return Column(children: rows);
}

Widget memberDetailInfoTile(MemberDetailInfoItem item) {
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
