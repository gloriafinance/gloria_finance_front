import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/settings/availability_accounts/pages/list_availability_accounts/widgets/view_availabilityAccount_account.dart';
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
      ),
      actionBuilders: [
        (account) => ButtonActionTable(
              color: AppColors.blue,
              text: "Visualizar",
              onPressed: () {
                _openModal(context, account);
              },
              icon: Icons.remove_red_eye_sharp,
            ),
      ],
    );
  }

  void _openModal(BuildContext context, AvailabilityAccountModel account) {
    ModalPage(
      title: isMobile(context)
          ? ""
          : 'Conta de disponibilidade #${account.availabilityAccountId}',
      body: ViewAvailabilityAccount(account: account),
    ).show(context);
  }

  List<dynamic> accountDTO(dynamic account) {
    return [
      account.accountName,
      account.accountType,
      formatCurrency(account.balance, symbol: account.symbol),
      account.active ? "Ativo" : "Inativo",
    ];
  }
}
