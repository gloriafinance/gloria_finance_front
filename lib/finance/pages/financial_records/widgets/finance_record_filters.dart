import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/finance/stores/finance_record_paginate_store.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/form_controls.dart';
import '../../../models/finance_record_model.dart';

final financeRecordPaginateStore = FinanceRecordPaginateStore();

class FinanceRecordFilters extends StatefulWidget {
  const FinanceRecordFilters({super.key});

  @override
  State<FinanceRecordFilters> createState() => _FinanceRecordFiltersState();
}

class _FinanceRecordFiltersState extends State<FinanceRecordFilters> {
  @override
  void initState() {
    super.initState();

    financeRecordPaginateStore.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 300,
                child: Dropdown(
                  label: "Fonte de financiamento",
                  items:
                      MoneyLocation.values.map((e) => e.friendlyName).toList(),
                  onChanged: (value) {},
                )),
            SizedBox(width: 10),
            SizedBox(
              width: 300,
              child: Input(
                label: "Data inicial",
                keyboardType: TextInputType.number,
                initialValue: financeRecordPaginateStore.state.filter.startDate,
                onChanged: (value) {},
                onTap: () {
                  _selectDate(context).then((picked) {
                    if (picked == null) return;
                    print(picked);
                    financeRecordPaginateStore.setStartDate(picked.toString());
                  });
                },
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 300,
              child: Input(
                label: "Data final",
                keyboardType: TextInputType.number,
                initialValue: financeRecordPaginateStore.state.filter.endDate,
                onChanged: (value) {},
                onTap: () {
                  _selectDate(context).then((picked) {
                    if (picked == null) return;
                    print(picked);
                    financeRecordPaginateStore.setEndDate(picked.toString());
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
                onPressed: () => applyFilter(),
              ),
            )
          ],
        )
      ],
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

  void applyFilter() {
    // contributionPaginationStore.apply();
  }
}
