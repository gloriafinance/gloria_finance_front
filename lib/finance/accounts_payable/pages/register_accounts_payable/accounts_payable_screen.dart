import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/providers/pages/suppliers/store/suppliers_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'store/form_accounts_payable_store.dart';
import 'widgets/form_account_payable.dart';

class AccountsPayableRegistrationScreen extends StatefulWidget {
  const AccountsPayableRegistrationScreen({super.key});

  @override
  State<AccountsPayableRegistrationScreen> createState() =>
      _AccountsPayableRegistrationScreenState();
}

class _AccountsPayableRegistrationScreenState
    extends State<AccountsPayableRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormAccountsPayableStore()),
        ChangeNotifierProvider(
            create: (_) => SuppliersListStore()..searchSuppliers())
      ],
      child: LayoutDashboard(
        _buildTitle(),
        screen: FormAccountPayable(),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Registrar Conta a Pagar',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }
}
