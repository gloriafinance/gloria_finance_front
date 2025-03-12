import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/availability_account_table.dart';

class AvailabilityAccountsListScreen extends StatefulWidget {
  const AvailabilityAccountsListScreen({super.key});

  @override
  State<AvailabilityAccountsListScreen> createState() =>
      _AvailabilityAccountsListScreenState();
}

class _AvailabilityAccountsListScreenState
    extends State<AvailabilityAccountsListScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          LayoutDashboard(_header(context), screen: AvailabilityAccountTable()),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Listagem de contas",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
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
            text: "Conta disponiblidade",
            onPressed: () =>
                GoRouter.of(context).go('/availability-accounts/add'),
            icon: Icons.add_box_outlined),
      ],
    );
  }
}
