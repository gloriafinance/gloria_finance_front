import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/accounts_payable_paginate_store.dart';
import 'widgets/accouts_payable_table.dart';

class AccountsPayableListScreen extends StatelessWidget {
  const AccountsPayableListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountsPayablePaginateStore()..searchAccountsPayable(),
      child: LayoutDashboard(_header(context), screen: AccountsPayableTable()),
    );
  }

  Widget _header(BuildContext context) {
    if (!isMobile(context)) {
      return Row(
        children: [
          Expanded(
            child: Text(
              'Contas a pagar',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                _newRecord(context),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contas a pagar',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [Expanded(child: _newRecord(context))],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _newRecord(BuildContext context) {
    return ButtonActionTable(
        color: AppColors.purple,
        text: "Registrar",
        onPressed: () => GoRouter.of(context).go('/accounts-payable/add'),
        icon: Icons.add_chart);
  }
}
