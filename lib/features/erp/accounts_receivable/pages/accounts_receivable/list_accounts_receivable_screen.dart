import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/general.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/accounts_receivable_store.dart';
import 'widgets/accounts_receivable_table.dart';
import 'widgets/accounts_receive_filters.dart';

class ListAccountsReceivableScreen extends StatelessWidget {
  const ListAccountsReceivableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => AccountsReceivableStore()..searchAccountsReceivable(),
      child: LayoutDashboard(
        _header(context),
        screen: Column(
          children: [AccountsReceiveFilters(), AccountsReceivableTable()],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    if (!isMobile(context)) {
      return Row(
        children: [
          Expanded(
            child: Text(
              'Lista de contas a receber',
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
            child: Row(children: [_newAccountReceivable(context)]),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contas a receber',
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: _newAccountReceivable(context))]),
          const SizedBox(height: 16),
        ],
      );
    }
  }

  Widget _newAccountReceivable(BuildContext context) {
    return ButtonActionTable(
      color: AppColors.purple,
      text: "Registrar conta a receber",
      onPressed: () => GoRouter.of(context).go('/accounts-receivables/add'),
      icon: Icons.account_balance_wallet,
    );
  }
}
