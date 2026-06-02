import 'package:flutter/material.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/tag_status.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../../models/member_model.dart';
import '../../../models/member_status.dart';
import '../../../store/pending_review_member_paginate_store.dart';

class PendingReviewMemberTable extends StatelessWidget {
  const PendingReviewMemberTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PendingReviewMemberPaginateStore>();
    final state = store.state;
    final l10n = AppLocalizations.of(context)!;

    if (state.makeRequest) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 40.0),
        child: const CircularProgressIndicator(),
      );
    }

    if (state.paginate.results.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Center(child: Text(l10n.member_pending_review_empty)),
      );
    }

    return CustomTable(
      headers: [
        l10n.member_list_header_name,
        l10n.member_list_header_email,
        l10n.member_list_header_phone,
        l10n.member_pending_review_header_created_at,
        l10n.member_list_header_status,
      ],
      data: FactoryDataTable<MemberModel>(
        data: state.paginate.results,
        dataBuilder: (member) => _memberDto(member, l10n),
      ),
      actionBuilders: [
        (member) => ButtonActionTable(
          color: AppColors.blue,
          text: l10n.member_pending_review_action_review,
          onPressed: () => _goToDetail(context, member as MemberModel),
          icon: Icons.remove_red_eye_outlined,
        ),
      ],
      paginate: PaginationData(
        totalRecords: state.paginate.count,
        nextPag: state.paginate.nextPag,
        perPage: state.paginate.perPage,
        currentPage: state.filter.page,
        onNextPag: store.nextPage,
        onPrevPag: store.prevPage,
        onChangePerPage: store.setPerPage,
      ),
    );
  }

  List<dynamic> _memberDto(MemberModel member, AppLocalizations l10n) {
    final color = switch (member.status) {
      MemberStatus.approved => Colors.green,
      MemberStatus.inactive => Colors.red,
      MemberStatus.pendingReview => Colors.orange,
    };
    final label = switch (member.status) {
      MemberStatus.approved => l10n.member_list_status_approved,
      MemberStatus.inactive => l10n.member_list_status_inactive,
      MemberStatus.pendingReview => l10n.member_list_status_pending_review,
    };

    return [
      member.name,
      member.email,
      member.phone,
      _formatDate(member.createdAt),
      tagStatus(color, label),
    ];
  }

  void _goToDetail(BuildContext context, MemberModel member) {
    GoRouter.of(context).go('/members/pending-review/${member.memberId}');
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return convertDateFormatToDDMMYYYY(value);
  }
}
