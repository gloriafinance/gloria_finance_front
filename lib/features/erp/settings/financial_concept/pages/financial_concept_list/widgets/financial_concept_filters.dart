import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinancialConceptFilters extends StatelessWidget {
  const FinancialConceptFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<FinancialConceptStore>();
    final l10n = context.l10n;

    final items = [
      l10n.settings_financial_concept_filter_all,
      ...FinancialConceptTypeExtension.listFriendlyName,
    ];
    final categoryItems = [
      l10n.settings_financial_concept_filter_all,
      ...StatementCategoryExtension.listFriendlyName,
    ];

    final selectedType = store.state.selectedType;
    final selectedStatementCategory = store.state.selectedStatementCategory;
    final initialValue =
        selectedType != null
            ? selectedType.friendlyName
            : l10n.settings_financial_concept_filter_all;
    final initialCategoryValue =
        selectedStatementCategory != null
            ? selectedStatementCategory.friendlyName
            : l10n.settings_financial_concept_filter_all;

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Dropdown(
                  label: l10n.settings_financial_concept_filter_by_type,
                  items: items,
                  initialValue: initialValue,
                  onChanged: (value) {
                    if (value == l10n.settings_financial_concept_filter_all) {
                      store.setTypeFilter(null);
                      return;
                    }

                    final selected = FinancialConceptType.values.firstWhere(
                      (element) => element.friendlyName == value,
                    );
                    store.setTypeFilter(selected);
                  },
                  labelSuffix: _clearFilterButton(
                    visible: selectedType != null,
                    onPressed: () => store.setTypeFilter(null),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Dropdown(
                  label:
                      l10n
                          .settings_financial_concept_filter_by_statement_category,
                  items: categoryItems,
                  initialValue: initialCategoryValue,
                  onChanged: (value) {
                    if (value == l10n.settings_financial_concept_filter_all) {
                      store.setStatementCategoryFilter(null);
                      return;
                    }

                    final selected = StatementCategoryExtension.fromFriendlyName(
                      value,
                    );
                    store.setStatementCategoryFilter(selected);
                  },
                  labelSuffix: _clearFilterButton(
                    visible: selectedStatementCategory != null,
                    onPressed: () => store.setStatementCategoryFilter(null),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonActionTable(
                icon: Icons.clear,
                color: AppColors.mustard,
                text: l10n.common_clear_filters,
                onPressed: store.clearFilter,
              ),
              const SizedBox(width: 12),
              ButtonActionTable(
                color: AppColors.blue,
                text: l10n.common_apply_filters,
                icon: Icons.search,
                onPressed: store.applyFilters,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _clearFilterButton({
    required bool visible,
    required VoidCallback onPressed,
  }) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onPressed,
      child: const Icon(Icons.close, size: 18, color: AppColors.greyMiddle),
    );
  }
}
