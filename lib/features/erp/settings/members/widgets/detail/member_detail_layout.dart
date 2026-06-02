import 'package:flutter/material.dart';

import '../../models/member_model.dart';
import 'member_detail_sections.dart';
import 'member_detail_support.dart';
import 'member_profile_summary_card.dart';

class MemberDetailLayout extends StatelessWidget {
  final MemberModel member;
  final bool mobile;
  final MemberDetailLabels labels;
  final Widget statusBadge;

  const MemberDetailLayout({
    super.key,
    required this.member,
    required this.mobile,
    required this.labels,
    required this.statusBadge,
  });

  @override
  Widget build(BuildContext context) {
    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MemberProfileSummaryCard(
            member: member,
            mobile: mobile,
            statusBadge: statusBadge,
            photoUnavailableLabel: labels.photoUnavailableLabel,
          ),
          const SizedBox(height: 20),
          MemberDetailSections(
            member: member,
            mobile: mobile,
            labels: labels,
            statusBadge: statusBadge,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 320,
          child: MemberProfileSummaryCard(
            member: member,
            mobile: mobile,
            statusBadge: statusBadge,
            photoUnavailableLabel: labels.photoUnavailableLabel,
          ),
        ),
        const SizedBox(width: 28),
        Expanded(
          child: MemberDetailSections(
            member: member,
            mobile: mobile,
            labels: labels,
            statusBadge: statusBadge,
          ),
        ),
      ],
    );
  }
}
