import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/finance_record_paginate_store.dart';

class FinanceRecordFilters extends StatefulWidget {
  const FinanceRecordFilters({super.key});

  @override
  State<FinanceRecordFilters> createState() => _FinanceRecordFiltersState();
}

class _FinanceRecordFiltersState extends State<FinanceRecordFilters> {
  bool isExpandedFilter = false;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanceRecordPaginateStore>(context);
    final storeConcept = Provider.of<FinancialConceptStore>(context);
    final availabilityAccountsListStore =
        Provider.of<AvailabilityAccountsListStore>(context);

    return isMobile(context)
        ? _layoutMobile(availabilityAccountsListStore, store, storeConcept)
        : _layoutDesktop(availabilityAccountsListStore, store, storeConcept);
  }

  Widget _layoutDesktop(
    AvailabilityAccountsListStore availabilityAccountsListStore,
    FinanceRecordPaginateStore store,
    FinancialConceptStore storeConcept,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _availabilityAccounts(
                  availabilityAccountsListStore,
                  store,
                ),
              ),
              SizedBox(width: 10),
              Expanded(flex: 2, child: _conceptType(store, storeConcept)),
              SizedBox(width: 10),
              Expanded(flex: 2, child: _concept(store, storeConcept)),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(flex: 1, child: _dateStart(store)),
              SizedBox(width: 10),
              Expanded(flex: 1, child: _dateEnd(store)),
              Expanded(flex: 3, child: SizedBox()),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _clearButton(store),
              SizedBox(width: 12),
              _applyFilterButton(store),
            ],
          ),
        ],
      ),
    );
  }

  Widget _layoutMobile(
    AvailabilityAccountsListStore availabilityAccountsListStore,
    FinanceRecordPaginateStore store,
    FinancialConceptStore storeConcept,
  ) {
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
                  context.l10n.common_filters_upper,
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
                      child: _availabilityAccounts(
                        availabilityAccountsListStore,
                        store,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _conceptType(store, storeConcept)),
                  ],
                ),
                Row(children: [Expanded(child: _concept(store, storeConcept))]),

                Row(
                  children: [
                    Expanded(child: _dateStart(store)),
                    SizedBox(width: 10),
                    Expanded(child: _dateEnd(store)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _clearButton(store)),
                    SizedBox(width: 10),
                    Expanded(child: _applyFilterButton(store)),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateStart(FinanceRecordPaginateStore store) {
    return Input(
      label: context.l10n.common_start_date,
      keyboardType: TextInputType.number,
      initialValue: store.state.filter.startDate,
      onChanged: (value) {},
      onTap: () {
        selectDate(context).then((picked) {
          if (picked == null) return;
          store.setStartDate(picked.toString());
        });
      },
    );
  }

  Widget _dateEnd(FinanceRecordPaginateStore store) {
    return Input(
      label: context.l10n.common_end_date,
      keyboardType: TextInputType.number,
      initialValue: store.state.filter.endDate,
      onChanged: (value) {},
      onTap: () {
        selectDate(context).then((picked) {
          if (picked == null) return;

          store.setEndDate(picked.toString());
        });
      },
    );
  }

  Widget _conceptType(
    FinanceRecordPaginateStore store,
    FinancialConceptStore storeConcept,
  ) {
    return Dropdown(
      label: context.l10n.finance_records_filter_concept_type,
      items: FinancialConceptTypeExtension.listFriendlyName,
      onChanged: (value) {
        final v = FinancialConceptType.values.firstWhere(
          (e) => e.friendlyName == value,
        );

        store.setConceptType(v.apiValue);
      },
    );
  }

  Widget _concept(
    FinanceRecordPaginateStore store,
    FinancialConceptStore storeConcept,
  ) {
    var items =
        storeConcept.state.financialConcepts.map((e) => e.name).toList();
    if (store.state.filter.conceptType != null) {
      items =
          storeConcept.state.financialConcepts
              .where(
                (element) => element.type == store.state.filter.conceptType,
              )
              .map((e) => e.name)
              .toList();
    }

    return Dropdown(
      label: context.l10n.finance_records_filter_concept,
      items: items,
      onChanged: (value) {
        final v = storeConcept.state.financialConcepts.firstWhere(
          (e) => e.name == value,
        );
        store.setFinancialConceptId(v.financialConceptId);
      },
    );
  }

  Widget _availabilityAccounts(
    AvailabilityAccountsListStore availabilityAccountsListStore,
    FinanceRecordPaginateStore store,
  ) {
    return Dropdown(
      label: context.l10n.finance_records_filter_availability_account,
      items:
          availabilityAccountsListStore.state.availabilityAccounts
              .map((a) => a.accountName)
              .toList(),
      onChanged: (value) {
        final selectedAccount = availabilityAccountsListStore
            .state
            .availabilityAccounts
            .firstWhere((e) => e.accountName == value);

        store.setAvailabilityAccountId(selectedAccount.availabilityAccountId);
      },
    );
  }

  Widget _applyFilterButton(FinanceRecordPaginateStore store) {
    final isLoading = store.state.makeRequest;
    final l10n = context.l10n;
    return ButtonActionTable(
      color: AppColors.blue,
      text: isLoading ? l10n.common_loading : l10n.common_apply_filters,
      icon: isLoading ? Icons.hourglass_bottom : Icons.search,
      onPressed: () {
        if (!isLoading) {
          isExpandedFilter = false;
          setState(() {});
          store.apply();
        }
      },
    );
  }

  Widget _clearButton(FinanceRecordPaginateStore store) {
    return ButtonActionTable(
      icon: Icons.clear,
      color: AppColors.mustard,
      text: context.l10n.common_clear_filters,
      onPressed: () {
        store.clearFilters();
      },
    );
  }
}
