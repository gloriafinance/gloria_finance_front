import 'package:gloria_finance/core/theme/index.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/open_gloria_assistance_context_button.dart';
import 'package:gloria_finance/features/erp/providers/pages/suppliers/store/suppliers_list_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          create: (_) => SuppliersListStore()..searchSuppliers(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(), FormAccountPayable()],
      ),
    );
  }

  Widget _buildHeader() {
    final title = context.l10n.accountsPayable_register_title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => context.go("/accounts-payable/list"),
              child: Icon(Icons.arrow_back_ios, color: AppColors.purple),
            ),
            Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        OpenGloriaAssistanceContextButton(
          question: context
              .l10n
              .support_assistant_context_accounts_payable_question,
          title: title,
          route: '/accounts-payable/add',
          module: 'accounts_payable',
          summary:
              'Screen used to register a payable commitment that will be paid later, with supplier, due dates and installments control.',
          relatedRoutes: const [
            '/financial-record/add',
            '/suppliers/register',
            '/financial-concepts',
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
