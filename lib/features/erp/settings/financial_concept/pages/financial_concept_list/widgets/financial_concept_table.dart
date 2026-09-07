import 'package:flutter/material.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/tag_status.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/pages/financial_concept_list/widgets/financial_concept_pix_dialog.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';
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
      headers: [
        context.l10n.settings_financial_concept_field_name,
        context.l10n.common_type,
        context.l10n.settings_financial_concept_field_statement_category,
        context.l10n.common_status,
        context.l10n.settings_financial_concept_pix_header,
      ],
      data: FactoryDataTable<FinancialConceptModel>(
        data: state.financialConcepts,
        dataBuilder: (concept) => _mapToRow(context, concept),
      ),
      actionBuilders: [
        (concept) =>
            _buildPixAction(context, concept as FinancialConceptModel, store),
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

  List<dynamic> _mapToRow(BuildContext context, FinancialConceptModel concept) {
    return [
      concept.name,
      getFriendlyNameFinancialConceptType(concept.type),
      getFriendlyNameStatementCategory(concept.statementCategory),
      concept.active
          ? tagStatus(AppColors.green, 'Ativo')
          : tagStatus(Colors.red, 'Inativo'),
      concept.pix == null
          ? Text(
            context.l10n.settings_financial_concept_pix_not_configured,
            style: TextStyle(fontFamily: AppFonts.fontText),
          )
          : tagStatus(
            AppColors.blue,
            context.l10n.settings_financial_concept_pix_configured,
          ),
    ];
  }

  Widget _buildPixAction(
    BuildContext context,
    FinancialConceptModel concept,
    FinancialConceptStore store,
  ) {
    final pix = concept.pix;
    if (pix != null) {
      return ButtonActionTable(
        color: AppColors.purple,
        text: context.l10n.settings_financial_concept_pix_view_action,
        icon: Icons.qr_code_2_outlined,
        onPressed:
            () => FinancialConceptPixDialog.show(
              context,
              conceptName: concept.name,
              copyPaste: pix.copyPaste,
              encodedImage: pix.encodedImage,
            ),
      );
    }

    final isCreating =
        store.state.creatingPixForConceptId == concept.financialConceptId;
    return ButtonActionTable(
      color: AppColors.purple,
      text:
          isCreating
              ? context.l10n.settings_financial_concept_pix_creating
              : context.l10n.settings_financial_concept_pix_create_action,
      icon: Icons.qr_code_2_outlined,
      isLoading: isCreating,
      onPressed: () => _createPix(context, concept, store),
    );
  }

  Future<void> _createPix(
    BuildContext context,
    FinancialConceptModel concept,
    FinancialConceptStore store,
  ) async {
    try {
      final pix = await store.createStaticPix(concept.financialConceptId);
      if (!context.mounted) return;
      await FinancialConceptPixDialog.show(
        context,
        conceptName: concept.name,
        copyPaste: pix.copyPaste,
        encodedImage: pix.encodedImage,
      );
      if (!context.mounted) return;
      await store.searchFinancialConcepts();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.settings_financial_concept_pix_creation_error,
          ),
        ),
      );
    }
  }

  void _navigateToEdit(BuildContext context, FinancialConceptModel concept) {
    GoRouter.of(context).go(
      '/financial-concepts/edit/${concept.financialConceptId}',
      extra: concept,
    );
  }
}
