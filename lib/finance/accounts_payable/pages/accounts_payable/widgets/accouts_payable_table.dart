import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_model.dart';
import 'package:church_finance_bk/finance/accounts_receivable/helpers/index.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/accounts_payable_paginate_store.dart';

class AccountsPayableTable extends StatefulWidget {
  const AccountsPayableTable({super.key});

  @override
  State<StatefulWidget> createState() => _AccountsPayableTableState();
}

class _AccountsPayableTableState extends State<AccountsPayableTable> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountsPayablePaginateStore>(context);
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
        child: Center(child: Text('Nāo ha contas a pagar para mostrar')),
      );
    }

    return CustomTable(
      headers: [
        "Fornecedor",
        "Descricao",
        "Nro. parcelas",
        "Pago",
        "Pendente",
        "Total a pagar",
        "Status"
      ],
      data: FactoryDataTable<AccountsPayableModel>(
          data: state.paginate.results, dataBuilder: accountsPayableDTO),
    );
  }

  List<dynamic> accountsPayableDTO(
    dynamic accountsPayable,
  ) {
    return [
      accountsPayable.supplier.name,
      accountsPayable.description,
      accountsPayable.countsInstallments().toString(),
      CurrencyFormatter.formatCurrency(accountsPayable.amountPaid),
      CurrencyFormatter.formatCurrency(accountsPayable.amountPending),
      CurrencyFormatter.formatCurrency(accountsPayable.amountTotal),
      tagStatus(
        getStatusColor(accountsPayable.status),
        AccountsPayableStatus.values
            .firstWhere((e) => e.name == accountsPayable.status)
            .friendlyName,
      ),
    ];
  }
}
