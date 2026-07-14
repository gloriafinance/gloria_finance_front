import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/tag_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/l10n/app_localizations.dart';
import '../../../models/member_model.dart';
import '../../../models/member_status.dart';
import '../../../store/member_paginate_store.dart';
import '../../../widgets/member_delete_confirmation_dialog.dart';

class MemberTable extends StatefulWidget {
  const MemberTable({super.key});

  @override
  State<MemberTable> createState() => _MemberTableState();
}

class _MemberTableState extends State<MemberTable> {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<MemberPaginateStore>();

    final state = store.state;

    if (state.makeRequest) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 40.0),
        child: CircularProgressIndicator(),
      );
    }

    if (state.paginate.results.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Center(
          child: Text(AppLocalizations.of(context)!.member_list_empty),
        ),
      );
    }

    return CustomTable(
      headers: [
        AppLocalizations.of(context)!.member_list_header_name,
        AppLocalizations.of(context)!.member_list_header_email,
        AppLocalizations.of(context)!.member_list_header_phone,
        AppLocalizations.of(context)!.member_list_header_birthdate,
        AppLocalizations.of(context)!.member_list_header_status,
      ],
      data: FactoryDataTable<MemberModel>(
        data: state.paginate.results,
        dataBuilder:
            (member) => memberDTO(member, AppLocalizations.of(context)!),
      ),
      actionBuilders: [
        (member) => ButtonActionTable(
          color: AppColors.purple,
          text: AppLocalizations.of(context)!.member_view_action,
          onPressed: () => _goToView(context, member as MemberModel),
          icon: Icons.visibility_outlined,
        ),
        (member) => ButtonActionTable(
          color: AppColors.blue,
          text: AppLocalizations.of(context)!.member_list_action_edit,
          onPressed: () => _goToEdit(context, member as MemberModel),
          icon: Icons.edit_outlined,
        ),
        (member) => ButtonActionTable(
          color: Colors.red,
          text: AppLocalizations.of(context)!.member_delete_action,
          onPressed: () => _deleteMember(context, store, member as MemberModel),
          icon: Icons.delete_outline,
        ),
      ],
      paginate: PaginationData(
        totalRecords: state.paginate.count,
        nextPag: state.paginate.nextPag,
        perPage: state.paginate.perPage,
        currentPage: state.filter.page,
        onNextPag: () {
          store.nextPage();
        },
        onPrevPag: () {
          store.prevPage();
        },
        onChangePerPage: (perPage) {
          store.setPerPage(perPage);
        },
      ),
    );
  }

  List<dynamic> memberDTO(dynamic member, AppLocalizations l10n) {
    final color = switch (member.status) {
      MemberStatus.approved => Colors.green,
      MemberStatus.inactive => Colors.red,
      MemberStatus.pendingReview => Colors.orange,
      _ => Colors.grey,
    };
    final label = switch (member.status) {
      MemberStatus.approved => l10n.member_list_status_approved,
      MemberStatus.inactive => l10n.member_list_status_inactive,
      MemberStatus.pendingReview => l10n.member_list_status_pending_review,
      _ => member.status.value,
    };
    return [
      member.name,
      member.email,
      member.phone,
      member.birthdate,
      tagStatus(color, label),
    ];
  }

  void _goToEdit(BuildContext context, MemberModel member) {
    GoRouter.of(context).go('/member/edit/${member.memberId}', extra: member);
  }

  void _goToView(BuildContext context, MemberModel member) {
    GoRouter.of(context).go('/member/view/${member.memberId}', extra: member);
  }

  Future<void> _deleteMember(
    BuildContext context,
    MemberPaginateStore store,
    MemberModel member,
  ) async {
    final confirmed = await showMemberDeleteConfirmationDialog(
      context,
      memberName: member.name,
    );
    if (confirmed != true || !context.mounted) return;

    final success = await store.deleteMember(member.memberId);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? AppLocalizations.of(context)!.member_delete_success
              : store.state.deleteError ??
                  AppLocalizations.of(context)!.member_delete_error,
        ),
      ),
    );
  }
}
