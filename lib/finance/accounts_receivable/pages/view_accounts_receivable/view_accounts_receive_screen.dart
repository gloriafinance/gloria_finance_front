import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import 'store/payment_account_receive_store.dart';
import 'widgets/account_receive.dart';

class ViewAccountsReceiveScreen extends StatelessWidget {
  final AccountsReceivableModel account;

  const ViewAccountsReceiveScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return LayoutDashboard(_header(context),
        screen: ChangeNotifierProvider<PaymentAccountReceiveStore>(
            create: (_) => PaymentAccountReceiveStore(),
            child: AccountReceive(
              account: account,
            )));
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go("/accounts-receivables"),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.purple,
          ),
        ),
        Text(
          'Detalhe da Contas a receber',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
