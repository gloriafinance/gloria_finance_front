import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/index.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/accounts_payable_model.dart';
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
        child: const CircularProgressIndicator(),
      );
    }

    if (state.paginate.results.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Center(
          child: Text(context.l10n.accountsPayable_table_empty),
        ),
      );
    }

    return CustomTable(
      headers: [
        context.l10n.accountsPayable_table_header_supplier,
        context.l10n.accountsPayable_table_header_description,
        context.l10n.accountsPayable_table_header_installments,
        context.l10n.accountsPayable_table_header_paid,
        context.l10n.accountsPayable_table_header_pending,
        context.l10n.accountsPayable_table_header_total,
        context.l10n.accountsPayable_table_header_status,
      ],
      data: FactoryDataTable<AccountsPayableModel>(
        data: state.paginate.results,
        dataBuilder: accountsPayableDTO,
      ),
      actionBuilders: [
        (accountPayable) => ButtonActionTable(
          color: AppColors.blue,
          text: context.l10n.accountsPayable_table_action_view,
          onPressed: () => _openDetail(context, accountPayable),
          icon: Icons.remove_red_eye_sharp,
        ),
      ],
    );
  }

  void _openDetail(BuildContext context, AccountsPayableModel accountPayable) {
    context.go('/account-payable/view', extra: accountPayable);
  }

  List<dynamic> accountsPayableDTO(dynamic accountsPayable) {
    final supplierName =
        accountsPayable.supplier?.name ?? accountsPayable.supplierName ?? '-';

    return [
      supplierName,
      accountsPayable.description,
      accountsPayable.countsInstallments().toString(),
      CurrencyFormatter.formatCurrency(accountsPayable.amountPaid ?? 0),
      CurrencyFormatter.formatCurrency(accountsPayable.amountPending ?? 0),
      CurrencyFormatter.formatCurrency(accountsPayable.amountTotal ?? 0),
      tagStatus(
        getStatusColor(accountsPayable.status ?? ''),
        accountsPayable.statusLabel,
      ),
    ];
  }
}
