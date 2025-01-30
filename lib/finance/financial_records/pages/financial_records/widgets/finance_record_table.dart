import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../settings/financial_concept/models/financial_concept_model.dart';
import '../../../models/finance_record_list_model.dart';
import '../store/finance_record_paginate_store.dart';
import 'view_finance_record.dart';

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
          alignment: Alignment.center,
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
        "Conta de disponiblidade"
      ],
      data: FactoryDataTable<FinanceRecordListModel>(
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
      actionBuilders: [
        (fianceRecord) => ButtonActionTable(
              color: AppColors.blue,
              text: "Visualizar",
              onPressed: () {
                _openModal(context, fianceRecord);
              },
              icon: Icons.remove_red_eye_sharp,
            ),
      ],
    );
  }

  void _openModal(BuildContext context, FinanceRecordListModel financeRecord) {
    ModalPage(
      title: isMobile(context)
          ? ""
          : 'Movimento financeiro #${financeRecord.financialRecordId}',
      body: ViewFinanceRecord(financeRecord: financeRecord),
    ).show(context);
  }

  List<dynamic> financeRecordDTO(dynamic financeRecord) {
    return [
      convertDateFormatToDDMMYYYY(financeRecord.date.toString()),
      formatCurrency(financeRecord.amount),
      getFriendlyNameFinancialConceptType(financeRecord.type),
      financeRecord.financialConcept.name,
      financeRecord.availabilityAccount.accountName,
      // getFriendlyNameMoneyLocation(financeRecord.availabilityAccountId),
    ];
  }
}
