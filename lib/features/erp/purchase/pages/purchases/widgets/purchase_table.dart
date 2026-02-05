import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/purchase_list_model.dart';
import '../store/purchase_paginate_store.dart';
import 'view_purchase.dart';

class PurchaseTable extends StatelessWidget {
  const PurchaseTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PurchasePaginateStore>();
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
        child: Center(child: Text('Nāo ha compras para mostrar')),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: CustomTable(
        headers: ["Data", "Descrição", "Imposto", "Valor"],
        data: FactoryDataTable<PurchaseListModel>(
          data: state.paginate.results,
          dataBuilder: purchaseDTO,
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
          (contribution) => ButtonActionTable(
            color: AppColors.blue,
            text: "Visualizar",
            onPressed: () {
              _openModal(context, contribution);
            },
            icon: Icons.remove_red_eye_sharp,
          ),
        ],
      ),
    );
  }

  void _openModal(BuildContext context, PurchaseListModel purchase) {
    ModalPage(
      title: isMobile(context) ? "" : 'Compra #${purchase.purchaseId}',
      body: ViewPurchase(purchase: purchase),
    ).show(context);
  }

  List<dynamic> purchaseDTO(dynamic purchase) {
    return [
      convertDateFormatToDDMMYYYY(purchase.purchaseDate),
      purchase.description,
      CurrencyFormatter.formatCurrency(purchase.tax),
      CurrencyFormatter.formatCurrency(purchase.total),
    ];
  }
}
