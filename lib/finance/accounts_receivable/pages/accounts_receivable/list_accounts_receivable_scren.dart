import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/helpers/general.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/toast.dart' show Toast;

class ListAccountsReceivableRegistrationScreen extends StatelessWidget {
  const ListAccountsReceivableRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return LayoutDashboard(
      _header(context),
      screen: Center(
        child: Text('Lista de contas a receber'),
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
            child: Row(
              children: [
                _newPurchase(context),
              ],
            ),
          ),
        ],
      );
    } else {
      return Text(
        'Contas a receber',
        style: TextStyle(
          fontFamily: AppFonts.fontTitle,
          fontSize: 20,
          color: Colors.black,
        ),
      );
    }
  }

  Widget _newPurchase(BuildContext context) {
    return ButtonActionTable(
        color: AppColors.purple,
        text: "Registrar conta a receber",
        onPressed: () => GoRouter.of(context).go('/accounts-receivables/add'),
        icon: Icons.account_balance_wallet);
  }
}
