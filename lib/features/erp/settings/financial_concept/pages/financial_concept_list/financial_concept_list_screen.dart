import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/financial_concept_model.dart';
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
        _FilterBar(),
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

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<FinancialConceptStore>();

    final items = [
      context.l10n.settings_financial_concept_filter_all,
      ...FinancialConceptTypeExtension.listFriendlyName,
    ];

    final selectedType = store.state.selectedType;
    final initialValue =
        selectedType != null ? selectedType.friendlyName : 'Todos';

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: SizedBox(
        width: 320,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelStyle: const TextStyle(fontFamily: AppFonts.fontSubTitle),
            labelText: context.l10n.settings_financial_concept_filter_by_type,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
          value: initialValue,
          items:
              items
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontFamily: AppFonts.fontSubTitle),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }

            if (value == context.l10n.settings_financial_concept_filter_all) {
              store.clearFilter();
              return;
            }

            final selected = FinancialConceptType.values.firstWhere(
              (element) => element.friendlyName == value,
            );
            store.filterByType(selected);
          },
        ),
      ),
    );
  }
}
