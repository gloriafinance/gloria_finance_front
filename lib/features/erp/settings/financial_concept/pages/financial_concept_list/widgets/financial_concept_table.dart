import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:church_finance_bk/features/erp//settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/features/erp//settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FinancialConceptTable extends StatelessWidget {
  const FinancialConceptTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<FinancialConceptStore>();
    final state = store.state;

    if (state.isLoading) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 40.0),
        child: const CircularProgressIndicator(),
      );
    }

    if (state.financialConcepts.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: const Center(
          child: Text(
            'Nenhum conceito financeiro cadastrado.',
            style: TextStyle(fontFamily: AppFonts.fontText),
          ),
        ),
      );
    }

    return CustomTable(
      headers: const ['Nome', 'Tipo', 'Categoria', 'Status'],
      data: FactoryDataTable<FinancialConceptModel>(
        data: state.financialConcepts,
        dataBuilder: (concept) => _mapToRow(concept),
      ),
      actionBuilders: [
        (concept) => ButtonActionTable(
          color: AppColors.blue,
          text: 'Editar',
          onPressed: () {
            _navigateToEdit(context, concept as FinancialConceptModel);
          },
          icon: Icons.edit_outlined,
        ),
      ],
    );
  }

  List<dynamic> _mapToRow(FinancialConceptModel concept) {
    return [
      concept.name,
      getFriendlyNameFinancialConceptType(concept.type),
      getFriendlyNameStatementCategory(concept.statementCategory),
      concept.active
          ? tagStatus(AppColors.green, 'Ativo')
          : tagStatus(Colors.red, 'Inativo'),
    ];
  }

  void _navigateToEdit(BuildContext context, FinancialConceptModel concept) {
    GoRouter.of(context).go(
      '/financial-concepts/edit/${concept.financialConceptId}',
      extra: concept,
    );
  }
}
