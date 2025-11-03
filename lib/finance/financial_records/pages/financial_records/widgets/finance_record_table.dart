import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/confirmation_dialog.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/tag_status.dart';
import '../../../../../settings/financial_concept/models/financial_concept_model.dart';
import '../../../models/finance_record_list_model.dart';
import '../../../models/finance_record_model.dart';
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
        child: CircularProgressIndicator(),
      );
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
        "Conta de disponiblidade",
        "Status",
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
        (fianceRecord) {
          // Solo mostrar el botón si es OUTGO y no está VOID ni RECONCILED
          if (fianceRecord.type == "OUTGO" &&
              fianceRecord.status != FinancialRecordStatus.VOID &&
              fianceRecord.status != FinancialRecordStatus.RECONCILED) {
            return ButtonActionTable(
              color: Colors.deepOrangeAccent,
              text: "Anular",
              onPressed: () async {
                var res = await confirmationDialog(
                  context,
                  "Deseja anular este movimento financeiro?",
                );

                if (res != null && res) {
                  store
                      .cancelFinanceRecord(fianceRecord.financialRecordId)
                      .then((value) {
                        if (value) {
                          store.searchFinanceRecords();
                        }
                      });
                }
              },
              icon: Icons.cancel_presentation_sharp,
            );
          }
          return SizedBox.shrink(); // Widget invisible
        },
      ],
    );
  }

  void _openModal(BuildContext context, FinanceRecordListModel financeRecord) {
    ModalPage(
      title: "Movimento financeiro",
      body: ViewFinanceRecord(financeRecord: financeRecord),
    ).show(context);
  }

  List<dynamic> financeRecordDTO(dynamic financeRecord) {
    var model = financeRecord as FinanceRecordListModel;
    return [
      convertDateFormatToDDMMYYYY(financeRecord.date.toString()),
      CurrencyFormatter.formatCurrency(financeRecord.amount),
      getFriendlyNameFinancialConceptType(financeRecord.type),
      financeRecord?.financialConcept?.name ?? 'N/A',
      financeRecord.availabilityAccount.accountName,
      tagStatus(
        model.status?.color ?? AppColors.green,
        model.status?.friendlyName ?? "-",
      ),
    ];
  }
}
