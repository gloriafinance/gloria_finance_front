import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/helpers/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/income_statement_model.dart';
import '../store/income_statement_store.dart';

class IncomeStatementTables extends StatelessWidget {
  const IncomeStatementTables({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<IncomeStatementStore>(context);
    final data = store.state.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sección de Activos
        _sectionTitle('Activos'),
        SizedBox(height: 16),
        _accountsTable(data.assets.accounts),
        SizedBox(height: 32),

        // Sección de Pasivos
        _sectionTitle('Pasivos (Centros de Costo)'),
        SizedBox(height: 16),
        _costCentersTable(data.liabilities.costCenters),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontFamily: AppFonts.fontTitle,
        color: AppColors.purple,
      ),
    );
  }

  Widget _accountsTable(List<AccountMaster> accounts) {
    if (accounts.isEmpty) {
      return Center(child: Text('No hay cuentas para mostrar'));
    }

    return CustomTable(
      headers: ["Contas", "Entradas", "Saidas", "Balance"],
      data: FactoryDataTable<AccountMaster>(
        data: accounts,
        dataBuilder: (account) {
          return [
            account.availabilityAccount.accountName,
            CurrencyFormatter.formatCurrency(account.totalInput,
                symbol: account.availabilityAccount.symbol),
            CurrencyFormatter.formatCurrency(account.totalOutput,
                symbol: account.availabilityAccount.symbol),
            CurrencyFormatter.formatCurrency(account.getBalance(),
                symbol: account.availabilityAccount.symbol)
          ];
        },
      ),
    );
  }

  Widget _costCentersTable(List<CostCenterMaster> costCenters) {
    if (costCenters.isEmpty) {
      return Center(child: Text('No hay centros de costo para mostrar'));
    }

    return CustomTable(
      headers: ["Centro de Costo", "Total", "Última Atividade"],
      data: FactoryDataTable<CostCenterMaster>(
        data: costCenters,
        dataBuilder: (costCenter) {
          return [
            costCenter.costCenter.costCenterName,
            CurrencyFormatter.formatCurrency(costCenter.getTotal()),
            "${costCenter.lastMove.day}/${costCenter.lastMove.month}/${costCenter.lastMove.year}",
          ];
        },
      ),
    );
  }
}
