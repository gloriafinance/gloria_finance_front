import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/settings/banks/models/bank_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/bank_form_store.dart';
import 'state/bank_form_state.dart';
import 'widgets/bank_form.dart';
import 'widgets/bank_form_venezuela.dart';

class BankFormScreen extends StatelessWidget {
  final BankModel? bank;

  const BankFormScreen({super.key, this.bank});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);
    final sessionStore = context.watch<AuthSessionStore>();
    final session = sessionStore.state.session;
    final isVenezuela = session.country.toUpperCase() == 'VE';
    final instructionType =
        isVenezuela ? BankInstructionType.venezuela : BankInstructionType.brazil;

    final title =
        bank != null
            ? context.l10n.settings_banks_form_title_edit
            : context.l10n.settings_banks_form_title_create;

    final form = isVenezuela ? const BankFormVenezuela() : const BankForm();

    return ChangeNotifierProvider(
      create:
          (_) => BankFormStore(bank: bank, instructionType: instructionType),
      child: _buildContent(context, title, form),
    );
  }

  Widget _buildContent(BuildContext context, String title, Widget form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => context.go('/banks'),
              child: const Icon(Icons.arrow_back_ios, color: AppColors.purple),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
        form,
      ],
    );
  }
}
