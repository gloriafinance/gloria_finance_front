import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
        child: Center(child: Text('Nāo ha membros cadastrados.')),
      );
    }

    return CustomTable(
      headers: ["Nome", "Email", "Telefone", "Data de nascimento", "Ativo?"],
      data: FactoryDataTable<MemberModel>(
        data: state.paginate.results,
        dataBuilder: memberDTO,
      ),
      actionBuilders: [
        (member) => ButtonActionTable(
              color: AppColors.blue,
              text: 'Editar',
              onPressed: () => _goToEdit(context, member as MemberModel),
              icon: Icons.edit_outlined,
            )
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

  List<dynamic> memberDTO(dynamic member) {
    return [
      member.name,
      member.email,
      member.phone,
      member.birthdate,
      //member.active ? "Sim" : "Nāo",
      member.active
          ? tagStatus(Colors.green, "Sim")
          : tagStatus(Colors.red, "Nāo"),
    ];
  }

  void _goToEdit(BuildContext context, MemberModel member) {
    GoRouter.of(context).go('/member/edit/${member.memberId}', extra: member);
  }
}
