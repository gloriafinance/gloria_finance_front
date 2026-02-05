import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/features/erp/settings/banks/store/bank_store.dart';
import 'package:gloria_finance/features/erp/bank_statements/models/bank_statement_model.dart';
import 'package:gloria_finance/features/erp/bank_statements/store/bank_statement_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankStatementFilters extends StatefulWidget {
  const BankStatementFilters({super.key});

  @override
  State<BankStatementFilters> createState() => _BankStatementFiltersState();
}

class _BankStatementFiltersState extends State<BankStatementFilters> {
  bool isExpandedFilter = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bankStore = context.watch<BankStore>();
    final store = context.watch<BankStatementListStore>();

    return isMobile(context)
        ? _layoutMobile(bankStore, store)
        : _layoutDesktop(bankStore, store);
  }

  Widget _layoutDesktop(BankStore bankStore, BankStatementListStore store) {
    final l10n = context.l10n;
    final filter = store.state.filter;
    final isLoading = store.state.loading;
    final yearNow = DateTime.now().year;
    final years = List<int>.generate(5, (index) => yearNow - index);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.common_filters,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 230,
                child: DropdownButtonFormField<String?>(
                  value: filter.bankId,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text(''),
                    ),
                    ...bankStore.state.banks.map(
                      (bank) => DropdownMenuItem<String?>(
                        value: bank.bankId,
                        child: Text('${bank.name} (${bank.tag})'),
                      ),
                    ),
                  ],
                  onChanged: (value) => store.setBank(value),
                  decoration: _decoration(l10n.common_bank),
                ),
              ),
              SizedBox(
                width: 200,
                child:
                    DropdownButtonFormField<BankStatementReconciliationStatus?>(
                  value: filter.status,
                  items: [
                    const DropdownMenuItem<BankStatementReconciliationStatus?>(
                      value: null,
                      child: Text(''),
                    ),
                    DropdownMenuItem(
                      value: BankStatementReconciliationStatus.pending,
                      child: Text(
                        BankStatementReconciliationStatus.pending.friendlyName,
                      ),
                    ),
                    DropdownMenuItem(
                      value: BankStatementReconciliationStatus.unmatched,
                      child: Text(
                        BankStatementReconciliationStatus.unmatched.friendlyName,
                      ),
                    ),
                    DropdownMenuItem(
                      value: BankStatementReconciliationStatus.reconciled,
                      child: Text(
                        BankStatementReconciliationStatus.reconciled.friendlyName,
                      ),
                    ),
                  ],
                  onChanged: (value) => store.setStatus(value),
                  decoration: _decoration(l10n.common_status),
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<int?>(
                  value: filter.month,
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text(''),
                    ),
                    ..._monthItems(),
                  ],
                  onChanged: (value) => store.setMonth(value),
                  decoration: _decoration(l10n.common_month),
                ),
              ),
              SizedBox(
                width: 160,
                child: DropdownButtonFormField<int?>(
                  value: filter.year,
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text(''),
                    ),
                    ...years.map(
                      (year) => DropdownMenuItem<int?>(
                        value: year,
                        child: Text(year.toString()),
                      ),
                    ),
                  ],
                  onChanged: (value) => store.setYear(value),
                  decoration: _decoration(l10n.common_year),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (filter.hasAnyFilter)
                ButtonActionTable(
                  color: AppColors.greyMiddle,
                  text: l10n.common_clear_filters,
                  icon: Icons.clear,
                  onPressed: () {
                    store.clearFilters();
                    store.fetchStatements();
                  },
                ),

              const SizedBox(width: 12),
              ButtonActionTable(
                color: AppColors.blue,
                text:
                    isLoading
                        ? l10n.common_loading
                        : l10n.common_apply_filters,
                icon: isLoading ? Icons.hourglass_bottom : Icons.search,
                onPressed: () {
                  if (!isLoading) {
                    store.fetchStatements();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _layoutMobile(BankStore bankStore, BankStatementListStore store) {
    final l10n = context.l10n;
    final filter = store.state.filter;
    final isLoading = store.state.loading;
    final yearNow = DateTime.now().year;
    final years = List<int>.generate(5, (index) => yearNow - index);

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          isExpandedFilter = isExpanded;
          setState(() {});
        },
        animationDuration: const Duration(milliseconds: 500),
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: isExpandedFilter,
            headerBuilder: (context, isOpen) {
              return ListTile(
                title: Text(
                  l10n.common_filters_upper,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.fontTitle,
                    color: AppColors.purple,
                  ),
                ),
              );
            },
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: filter.bankId,
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text(''),
                          ),
                          ...bankStore.state.banks.map(
                            (bank) => DropdownMenuItem<String?>(
                              value: bank.bankId,
                              child: Text('${bank.name} (${bank.tag})'),
                            ),
                          ),
                        ],
                        onChanged: (value) => store.setBank(value),
                        decoration: _decoration(l10n.common_bank),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<
                        BankStatementReconciliationStatus?
                      >(
                        value: filter.status,
                        items: [
                          const DropdownMenuItem<BankStatementReconciliationStatus?>(
                            value: null,
                            child: Text(''),
                          ),
                          DropdownMenuItem(
                            value: BankStatementReconciliationStatus.pending,
                            child: Text(
                              BankStatementReconciliationStatus
                                  .pending
                                  .friendlyName,
                            ),
                          ),
                          DropdownMenuItem(
                            value: BankStatementReconciliationStatus.unmatched,
                            child: Text(
                              BankStatementReconciliationStatus
                                  .unmatched
                                  .friendlyName,
                            ),
                          ),
                          DropdownMenuItem(
                            value: BankStatementReconciliationStatus.reconciled,
                            child: Text(
                              BankStatementReconciliationStatus
                                  .reconciled
                                  .friendlyName,
                            ),
                          ),
                        ],
                        onChanged: (value) => store.setStatus(value),
                        decoration: _decoration(l10n.common_status),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        value: filter.month,
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text(''),
                          ),
                          ..._monthItems(),
                        ],
                        onChanged: (value) => store.setMonth(value),
                        decoration: _decoration(l10n.common_month),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        value: filter.year,
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text(''),
                          ),
                          ...years.map(
                            (year) => DropdownMenuItem<int?>(
                              value: year,
                              child: Text(year.toString()),
                            ),
                          ),
                        ],
                        onChanged: (value) => store.setYear(value),
                        decoration: _decoration(l10n.common_year),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (filter.hasAnyFilter)
                      Expanded(
                        child: ButtonActionTable(
                          icon: Icons.clear,
                          color: AppColors.mustard,
                          text: l10n.common_clear_filters,
                          onPressed: () {
                            isExpandedFilter = false;
                            setState(() {});
                            store.clearFilters();
                            store.fetchStatements();
                          },
                        ),
                      ),
                    if (filter.hasAnyFilter) const SizedBox(width: 10),
                    Expanded(
                      child: ButtonActionTable(
                        color: AppColors.blue,
                        text:
                            isLoading
                                ? l10n.common_loading
                                : l10n.common_apply_filters,
                        icon: isLoading ? Icons.hourglass_bottom : Icons.search,
                        onPressed: () {
                          if (!isLoading) {
                            isExpandedFilter = false;
                            setState(() {});
                            store.fetchStatements();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int?>> _monthItems() {
    final l10n = context.l10n;
    final labels = <String>[
      l10n.month_january,
      l10n.month_february,
      l10n.month_march,
      l10n.month_april,
      l10n.month_may,
      l10n.month_june,
      l10n.month_july,
      l10n.month_august,
      l10n.month_september,
      l10n.month_october,
      l10n.month_november,
      l10n.month_december,
    ];

    return List.generate(
      12,
      (index) => DropdownMenuItem<int?>(
        value: index + 1,
        child: Text(labels[index]),
      ),
    );
  }

  static InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: AppColors.purple,
        fontFamily: AppFonts.fontSubTitle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.greyMiddle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.greyMiddle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.blue),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
