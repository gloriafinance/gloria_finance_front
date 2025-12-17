import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:church_finance_bk/l10n/app_localizations.dart';
import '../../../models/member_model.dart';
import '../../../store/member_paginate_store.dart';

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
        AppLocalizations.of(context)!.member_list_header_active,
      ],
      data: FactoryDataTable<MemberModel>(
        data: state.paginate.results,
        dataBuilder:
            (member) => memberDTO(member, AppLocalizations.of(context)!),
      ),
      actionBuilders: [
        (member) => ButtonActionTable(
          color: AppColors.blue,
          text: AppLocalizations.of(context)!.member_list_action_edit,
          onPressed: () => _goToEdit(context, member as MemberModel),
          icon: Icons.edit_outlined,
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
    return [
      member.name,
      member.email,
      member.phone,
      member.birthdate,
      //member.active ? "Sim" : "Nāo",
      member.active
          ? tagStatus(Colors.green, l10n.member_list_status_yes)
          : tagStatus(Colors.red, l10n.member_list_status_no),
    ];
  }

  void _goToEdit(BuildContext context, MemberModel member) {
    GoRouter.of(context).go('/member/edit/${member.memberId}', extra: member);
  }
}
