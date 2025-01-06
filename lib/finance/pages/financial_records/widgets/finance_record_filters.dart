import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/form_controls.dart';
import '../../../models/finance_record_model.dart';
import '../../../stores/finance_record_paginate_store.dart';
import '../financial_record_screen.dart';

class FinanceRecordFilters extends StatefulWidget {
  const FinanceRecordFilters({super.key});

  @override
  State<FinanceRecordFilters> createState() => _FinanceRecordFiltersState();
}

class _FinanceRecordFiltersState extends State<FinanceRecordFilters> {
  @override
  void initState() {
    super.initState();

    // financeRecordPaginateStore.addListener(() {
    //   setState(() {});
    // });

    financialConceptStore.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanceRecordPaginateStore>(context);

    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Dropdown(
                    label: "Fonte de financiamento",
                    items: MoneyLocation.values
                        .map((e) => e.friendlyName)
                        .toList(),
                    onChanged: (value) {},
                  )),
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Dropdown(
                  label: "Conceito",
                  items: financialConceptStore.state.financialConcepts
                      .map((e) => e.name)
                      .toList(),
                  onChanged: (value) {
                    final v = financialConceptStore.state.financialConcepts
                        .firstWhere((e) => e.name == value);
                    store.setFinancialConceptId(v.financialConceptId);
                  },
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 200,
                child: Input(
                  label: "Data inicial",
                  keyboardType: TextInputType.number,
                  initialValue: store.state.filter.startDate,
                  onChanged: (value) {},
                  onTap: () {
                    _selectDate(context).then((picked) {
                      if (picked == null) return;
                      store.setStartDate(picked.toString());
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 200,
                child: Input(
                  label: "Data final",
                  keyboardType: TextInputType.number,
                  initialValue: store.state.filter.endDate,
                  onChanged: (value) {},
                  onTap: () {
                    _selectDate(context).then((picked) {
                      if (picked == null) return;

                      store.setEndDate(picked.toString());
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Container(
                margin: EdgeInsets.only(top: 53),
                child: CustomButton(
                  text: "Filtrar",
                  backgroundColor: AppColors.purple,
                  width: 100,
                  textColor: Colors.white,
                  onPressed: () => store.apply(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Fecha inicial
      firstDate: DateTime(2000),
      // Fecha mínima
      lastDate: DateTime(2100),
      // Fecha máxima
      helpText: 'Selecciona una fecha',
    );
  }
}
