import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/availability_accounts_list_store.dart';

class AvailabilityAccountTable extends StatefulWidget {
  const AvailabilityAccountTable({super.key});

  @override
  State<StatefulWidget> createState() => _AvailabilityAccountTable();
}

class _AvailabilityAccountTable extends State<AvailabilityAccountTable> {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<AvailabilityAccountsListStore>();

    final state = store.state;

    if (state.makeRequest) {
      return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 40.0),
          child: CircularProgressIndicator());
    }

    if (state.availabilityAccounts.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Center(child: Text('Nāo ha contas cadastradas.')),
      );
    }

    return CustomTable(
        headers: ["Nome da conta", "Tipo de conta", "balane", "status"],
        data: FactoryDataTable<dynamic>(
          data: state.availabilityAccounts,
          dataBuilder: accountDTO,
        ));
  }

  List<dynamic> accountDTO(dynamic account) {
    return [
      account.accountName,
      account.accountType,
      formatCurrency(account.balance),
      account.active ? "Ativo" : "Inativo",
    ];
  }
}
