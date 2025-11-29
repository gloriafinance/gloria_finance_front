import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/features/erp//settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/features/erp//settings/financial_concept/pages/form_financial_concept/store/financial_concept_form_store.dart';
import 'package:church_finance_bk/features/erp//settings/financial_concept/pages/form_financial_concept/widgets/financial_concept_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FinancialConceptFormScreen extends StatelessWidget {
  final FinancialConceptModel? concept;

  const FinancialConceptFormScreen({super.key, this.concept});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    final title =
        concept != null
            ? 'Editar conceito financeiro'
            : 'Cadastrar conceito financeiro';

    return ChangeNotifierProvider(
      create: (_) => FinancialConceptFormStore(concept: concept),
      child: LayoutDashboard(
        Row(
          children: [
            GestureDetector(
              onTap: () => context.go('/financial-concepts'),
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
        screen: const FinancialConceptForm(),
      ),
    );
  }
}
