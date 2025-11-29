import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/features/erp/settings/banks/models/bank_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/bank_form_store.dart';
import 'widgets/bank_form.dart';

class BankFormScreen extends StatelessWidget {
  final BankModel? bank;

  const BankFormScreen({super.key, this.bank});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    final title = bank != null ? 'Editar banco' : 'Cadastrar banco';

    return ChangeNotifierProvider(
      create: (_) => BankFormStore(bank: bank),
      child: LayoutDashboard(
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
        screen: const BankForm(),
      ),
    );
  }
}
