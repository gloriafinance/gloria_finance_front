import 'package:flutter/material.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/tag_status.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/pages/financial_concept_list/widgets/financial_concept_actions_menu.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FinancialConceptTable extends StatelessWidget {
  const FinancialConceptTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<FinancialConceptStore>();
    final state = store.state;
    final isBrazil =
        context.watch<AuthSessionStore>().state.session.country.toUpperCase() ==
        'BR';

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
        child: Center(
          child: Text(
            context.l10n.settings_financial_concept_empty,
            style: const TextStyle(fontFamily: AppFonts.fontText),
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
        (concept) => FinancialConceptActionsMenu(
          concept: concept as FinancialConceptModel,
          store: store,
          showPixAction: isBrazil,
          onEdit: () {
            final selectedConcept = concept;
            GoRouter.of(context).go(
              '/financial-concepts/edit/${selectedConcept.financialConceptId}',
              extra: selectedConcept,
            );
          },
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
          ? tagStatus(
            AppColors.green,
            context.l10n.settings_church_profile_status_active,
          )
          : tagStatus(
            Colors.red,
            context.l10n.settings_church_profile_status_inactive,
          ),
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
}
