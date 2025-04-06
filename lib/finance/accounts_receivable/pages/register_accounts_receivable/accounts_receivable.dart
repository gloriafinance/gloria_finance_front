import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/form_accounts_receivable_store.dart';
import 'widgets/form_accounts_receivable.dart';

class AccountsReceivableRegistrationScreen extends StatelessWidget {
  const AccountsReceivableRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormAccountsReceivableStore()),
      ],
      child: LayoutDashboard(
        _header(context),
        screen: FormAccountsReceivable(),
      ),
    );
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
          'Registro de contas a receber',
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
