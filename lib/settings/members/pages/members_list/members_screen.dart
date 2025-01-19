import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'stores/member_paginate_store.dart';
import 'widgets/member_table.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => MemberPaginateStore()..searchMemberList()),
        ],
        child: MaterialApp(
            home: LayoutDashboard(_header(context), screen: MemberTable())));
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Listado de membros",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontMedium,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _buttons(context),
        ),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(
      children: [
        ButtonActionTable(
            color: AppColors.purple,
            text: "Registrar novo membro",
            onPressed: () => GoRouter.of(context).go('/member/add'),
            icon: Icons.add_reaction_outlined),
      ],
    );
  }
}
