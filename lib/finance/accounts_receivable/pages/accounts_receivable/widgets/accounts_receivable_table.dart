import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../helpers/index.dart';
import '../../../models/index.dart';
import '../store/accounts_receivable_store.dart';

class AccountsReceivableTable extends StatelessWidget {
  const AccountsReceivableTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountsReceivableStore>(context);
    final state = store.state;

    if (state.makeRequest) {
      return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 40.0),
          child: CircularProgressIndicator());
    }

    if (state.paginate.results.isEmpty) {
      return Center(child: Text('Nenhuma conta a receber encontrada'));
    }

    return Container(
      margin: isMobile(context) ? null : const EdgeInsets.only(top: 40.0),
      child: CustomTable(
        headers: [
          "Devedor",
          "Descricao",
          "Nro. parcelas",
          "Recebido",
          "Pendente",
          "Total a receber",
          "Status"
        ],
        data: FactoryDataTable<AccountsReceivableModel>(
            data: state.paginate.results, dataBuilder: accountsReceivableDTO),
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
            }),
        actionBuilders: [
          (accountsReceivable) => ButtonActionTable(
                color: AppColors.blue,
                text: "Visualizar",
                onPressed: () => _openDetail(context, accountsReceivable),
                icon: Icons.remove_red_eye_sharp,
              ),
        ],
      ),
    );
  }

  void _openDetail(
      BuildContext context, AccountsReceivableModel accountsReceivable) {
    context.go('/account-receivables/view', extra: accountsReceivable);
  }

  List<dynamic> accountsReceivableDTO(dynamic accountsReceivable) {
    return [
      accountsReceivable.debtor.name,
      accountsReceivable.description,
      accountsReceivable.installments.length.toString(),
      CurrencyFormatter.formatCurrency(accountsReceivable.amountPaid),
      CurrencyFormatter.formatCurrency(accountsReceivable.amountPending),
      CurrencyFormatter.formatCurrency(accountsReceivable.amountTotal),
      tagStatus(
        getStatusColor(accountsReceivable.status),
        AccountsReceivableStatus.values
            .firstWhere((e) =>
                e.toString().split('.').last == accountsReceivable.status)
            .friendlyName,
      )
    ];
  }
}
