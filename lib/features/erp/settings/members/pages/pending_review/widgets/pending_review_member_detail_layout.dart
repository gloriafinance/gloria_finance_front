import 'package:flutter/material.dart';

import '../../../models/member_model.dart';
import 'pending_review_member_detail_sections.dart';
import 'pending_review_member_identity_panel.dart';

class PendingReviewMemberDetailLayout extends StatelessWidget {
  final MemberModel member;
  final bool mobile;

  const PendingReviewMemberDetailLayout({
    super.key,
    required this.member,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PendingReviewMemberIdentityPanel(member: member, mobile: mobile),
          const SizedBox(height: 20),
          PendingReviewMemberDetailSections(member: member, mobile: mobile),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 320,
          child: PendingReviewMemberIdentityPanel(member: member, mobile: mobile),
        ),
        const SizedBox(width: 28),
        Expanded(
          child: PendingReviewMemberDetailSections(member: member, mobile: mobile),
        ),
      ],
    );
  }
}
