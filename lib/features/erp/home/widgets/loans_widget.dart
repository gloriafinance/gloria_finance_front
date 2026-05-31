import 'package:flutter/material.dart';
import 'package:gloria_finance/core/widgets/card_amount.dart';
import 'package:gloria_finance/features/erp/accounts_receivable/accounts_receivable_service.dart';
import 'package:gloria_finance/features/erp/home/models/dashboard_loans_model.dart';

class LoansWidget extends StatefulWidget {
  const LoansWidget({super.key});

  @override
  State<StatefulWidget> createState() => _LoansWidget();
}

class _LoansWidget extends State<LoansWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AccountsReceivableService().getDashboardLoans(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DashboardLoanModel?> snapshot,
      ) {
        final data = snapshot.data;

        return CardAmount(
          title: "Empréstimos concedidos",
          amount: data?.total ?? 0,
          bgColor: Colors.green,
          subtitle: "Total emprestados ${data?.loans?.length ?? 0}",
          symbol: "R\$",
          icon: Icons.auto_graph_rounded,
        );
      },
    );
  }
}
