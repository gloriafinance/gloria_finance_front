import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/accounts_payable_model.dart';
import 'store/payment_account_payable_state.dart';
import 'widgets/account_payable.dart';

class ViewAccountPayableScreen extends StatelessWidget {
  final AccountsPayableModel account;

  const ViewAccountPayableScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(context),
        ChangeNotifierProvider(
          create: (_) => PaymentAccountPayableStore(),
          child: AccountPayable(account: account),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go("/accounts-payable/list"),
          child: Icon(Icons.arrow_back_ios, color: AppColors.purple),
        ),
        Text(
          'Detalhe da Contas a pagar',
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
