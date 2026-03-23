import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/open_gloria_assistance_context_button.dart';

import 'store/internal_transfer_form_store.dart';
import 'widgets/internal_transfer_form.dart';

class InternalTransferFormScreen extends StatelessWidget {
  const InternalTransferFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InternalTransferFormStore()),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go('/financial-record/internal-transfer'),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.purple,
                ),
              ),
              Text(
                context.l10n.finance_records_transfer_form_title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OpenGloriaAssistanceContextButton(
            question:
                context
                    .l10n
                    .support_assistant_context_internal_transfer_question,
            title: context.l10n.finance_records_transfer_form_title,
            route: '/financial-record/internal-transfer/add',
            module: 'financial_records',
            summary:
                'Screen used to move money between church availability accounts without creating a normal income or expense.',
            relatedRoutes: const [
              '/financial-record/internal-transfer',
              '/financial-record/add',
              '/availability-accounts',
            ],
          ),
          const SizedBox(height: 12),
          const InternalTransferForm(),
        ],
      ),
    );
  }
}
