// lib/finance/reports/pages/income_statement/widgets/income_statement_cards.dart

import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/card_amount.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/income_statement_store.dart';

class IncomeStatementCards extends StatelessWidget {
  const IncomeStatementCards({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<IncomeStatementStore>(context);
    final data = store.state.data;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Tarjeta para el resultado (puede ser positivo o negativo)
          CardAmount(
            title: 'Resultado',
            amount: data.result,
            symbol: 'R\$',
            bgColor: data.result >= 0 ? AppColors.green : Colors.red,
            icon: data.result >= 0 ? Icons.trending_up : Icons.trending_down,
          ),
          SizedBox(width: 20),
          // Tarjeta para los activos
          CardAmount(
            title: 'Total de Activos',
            amount: data.assets.total,
            symbol: 'R\$',
            bgColor: AppColors.blue,
            icon: Icons.account_balance,
          ),
          SizedBox(width: 20),
          // Tarjeta para los pasivos
          CardAmount(
            title: 'Total de Pasivos',
            amount: data.liabilities.total,
            symbol: 'R\$',
            bgColor: AppColors.purple,
            icon: Icons.account_balance_wallet,
          ),
        ],
      ),
    );
  }
}
