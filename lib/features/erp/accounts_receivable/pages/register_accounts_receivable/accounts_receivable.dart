import 'package:gloria_finance/core/theme/index.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/open_gloria_assistance_context_button.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(context), FormAccountsReceivable()],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final title = context.l10n.accountsReceivable_register_title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => context.go("/accounts-receivables"),
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
              .support_assistant_context_accounts_receivable_question,
          title: title,
          route: '/accounts-receivables/add',
          module: 'accounts_receivable',
          summary:
              'Screen used to register an amount the church expects to receive later, with debtor, installments and collection follow-up.',
          relatedRoutes: const [
            '/financial-record/add',
            '/financial-concepts',
            '/accounts-receivables',
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
