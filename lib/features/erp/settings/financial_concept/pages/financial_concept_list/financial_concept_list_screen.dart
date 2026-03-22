import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'widgets/financial_concept_filters.dart';
import 'widgets/financial_concept_table.dart';

class FinancialConceptListScreen extends StatefulWidget {
  const FinancialConceptListScreen({super.key});

  @override
  State<FinancialConceptListScreen> createState() =>
      _FinancialConceptListScreenState();
}

class _FinancialConceptListScreenState
    extends State<FinancialConceptListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<FinancialConceptStore>();
      if (!store.state.isLoading && store.state.financialConcepts.isEmpty) {
        store.searchFinancialConcepts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(context),

        SizedBox(height: 24),
        const FinancialConceptFilters(),
        FinancialConceptTable(),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.settings_financial_concept_title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ButtonActionTable(
            color: AppColors.purple,
            text: context.l10n.settings_financial_concept_new,
            onPressed: () => GoRouter.of(context).go('/financial-concepts/add'),
            icon: Icons.add_box_outlined,
          ),
        ),
      ],
    );
  }
}
