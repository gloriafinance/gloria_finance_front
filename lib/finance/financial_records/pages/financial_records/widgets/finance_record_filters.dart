import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../store/finance_record_paginate_store.dart';

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
      FinancialConceptStore storeConcept) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: _availabilityAccounts(
                                  availabilityAccountsListStore, store)),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: _concept(store, storeConcept),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _dateStart(store),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: _dateEnd(store),
                          ),
                          SizedBox(width: 10),
                        ],
                      )
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50.0),
                        child: _applyFilterButton(store),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: _clearButton(store),
                      ),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget _layoutMobile(
      AvailabilityAccountsListStore availabilityAccountsListStore,
      FinanceRecordPaginateStore store,
      FinancialConceptStore storeConcept) {
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
                      "Filtros",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppFonts.fontMedium,
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
                                availabilityAccountsListStore, store)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _concept(store, storeConcept))
                      ],
                    ),
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
                        Expanded(child: _applyFilterButton(store)),
                        SizedBox(width: 10),
                        Expanded(child: _clearButton(store)),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ))
          ],
        ));
  }

  Widget _dateStart(FinanceRecordPaginateStore store) {
    return Input(
      label: "Data inicial",
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
      label: "Data final",
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

  Widget _concept(
      FinanceRecordPaginateStore store, FinancialConceptStore storeConcept) {
    return Dropdown(
      label: "Conceito",
      items: storeConcept.state.financialConcepts.map((e) => e.name).toList(),
      onChanged: (value) {
        final v = storeConcept.state.financialConcepts
            .firstWhere((e) => e.name == value);
        store.setFinancialConceptId(v.financialConceptId);
      },
    );
  }

  Widget _availabilityAccounts(
      AvailabilityAccountsListStore availabilityAccountsListStore,
      FinanceRecordPaginateStore store) {
    return Dropdown(
        label: "Conta de disponiblidade",
        items: availabilityAccountsListStore.state.availabilityAccounts
            .map((a) => a.accountName)
            .toList(),
        onChanged: (value) {
          final selectedAccount = availabilityAccountsListStore
              .state.availabilityAccounts
              .firstWhere((e) => e.accountName == value);

          store.setAvailabilityAccountId(selectedAccount.availabilityAccountId);
        });
  }

  Widget _applyFilterButton(FinanceRecordPaginateStore store) {
    return CustomButton(
      text: "Filtrar",
      backgroundColor: AppColors.purple,
      textColor: Colors.white,
      onPressed: () {
        isExpandedFilter = false;
        setState(() {});
        store.apply();
      },
    );
  }

  Widget _clearButton(FinanceRecordPaginateStore store) {
    return CustomButton(
      text: "Limpar",
      backgroundColor: AppColors.greyLight,
      textColor: Colors.white,
      onPressed: () => store.clearFilters(),
    );
  }
}
