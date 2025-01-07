import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/form_controls.dart';
import '../../../models/finance_record_model.dart';
import '../../../stores/finance_concept_store.dart';
import '../../../stores/finance_record_paginate_store.dart';

class FinanceRecordFilters extends StatefulWidget {
  const FinanceRecordFilters({super.key});

  @override
  State<FinanceRecordFilters> createState() => _FinanceRecordFiltersState();
}

class _FinanceRecordFiltersState extends State<FinanceRecordFilters> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanceRecordPaginateStore>(context);
    final storeConcept = Provider.of<FinancialConceptStore>(context);

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
                              child: Dropdown(
                                label: "Fonte de financiamento",
                                items: MoneyLocation.values
                                    .map((e) => e.friendlyName)
                                    .toList(),
                                onChanged: (value) =>
                                    store.setMoneyLocation(value),
                              )),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Dropdown(
                              label: "Conceito",
                              items: storeConcept.state.financialConcepts
                                  .map((e) => e.name)
                                  .toList(),
                              onChanged: (value) {
                                final v = storeConcept.state.financialConcepts
                                    .firstWhere((e) => e.name == value);
                                store.setFinancialConceptId(
                                    v.financialConceptId);
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Input(
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
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Input(
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
                            ),
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
                        child: CustomButton(
                          text: "Filtrar",
                          backgroundColor: AppColors.purple,
                          textColor: Colors.white,
                          onPressed: () => store.apply(),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: CustomButton(
                          text: "Limpar",
                          backgroundColor: AppColors.greyLight,
                          textColor: Colors.white,
                          onPressed: () => store.clearFilters(),
                        ),
                      ),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
