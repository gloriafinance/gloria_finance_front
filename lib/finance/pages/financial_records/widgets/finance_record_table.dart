import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/finance_record_model.dart';
import '../../../stores/finance_record_paginate_store.dart';

class FinanceRecordTable extends StatefulWidget {
  const FinanceRecordTable({super.key});

  @override
  State<FinanceRecordTable> createState() => _FinanceRecordTableState();
}

class _FinanceRecordTableState extends State<FinanceRecordTable> {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<FinanceRecordPaginateStore>();

    final state = store.state;

    if (state.makeRequest) {
      return Container(
          margin: const EdgeInsets.only(top: 40.0),
          child: CircularProgressIndicator());
    }

    if (state.paginate.results.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Center(child: Text('Nāo ha dados financeiros para mostrar')),
      );
    }

    return CustomTable(
      headers: [
        "Data",
        "Valor",
        "Tipo de movimento",
        "Conceito",
        "Fonte de financiamento"
      ],
      data: FactoryDataTable<FinanceRecordModel>(
        data: state.paginate.results,
        dataBuilder: financeRecordDTO,
      ),
      paginate: PaginationData(
        totalRecords: state.paginate.count,
        nextPag: state.paginate.nextPag,
        perPage: state.paginate.perPage,
        currentPage: state.filter.page,
        onNextPag: () {
          store.nextPage();
        },
        onPrevPag: () {
          store.prevPage();
        },
        onChangePerPage: (perPage) {
          store.setPerPage(perPage);
        },
      ),
    );
  }

  List<dynamic> financeRecordDTO(dynamic financeRecord) {
    return [
      convertDateFormatToDDMMYYYY(financeRecord.date.toString()),
      formatCurrency(financeRecord.amount),
      financeRecord.type,
      financeRecord.financialConcept.name,
      getFriendlyNameFromApiValue(financeRecord.moneyLocation),
    ];
  }
}
