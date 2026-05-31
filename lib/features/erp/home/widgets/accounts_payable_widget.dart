import 'package:flutter/material.dart';
import 'package:gloria_finance/core/widgets/card_amount.dart';
import 'package:gloria_finance/features/erp/accounts_payable/accounts_payable_service.dart';
import 'package:gloria_finance/features/erp/home/models/dashboard_account_payable_model.dart';

class AccountsPayableWidget extends StatefulWidget {
  const AccountsPayableWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AccountsPayableWidget();
}

class _AccountsPayableWidget extends State<AccountsPayableWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AccountsPayableService().getDashboardAccountsPayable(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DashboardAccountPayableModel?> snapshot,
      ) {
        final data = snapshot.data;

        return CardAmount(
          title: "Dívidas a pagar",
          amount: data?.total ?? 0,
          bgColor: Colors.orange,
          subtitle:
              "Total de compromissos financeiros a pagar ${data?.accounts?.length ?? 0}",
          symbol: "R\$",
          icon: Icons.warning_amber,
        );
      },
    );
  }
}
