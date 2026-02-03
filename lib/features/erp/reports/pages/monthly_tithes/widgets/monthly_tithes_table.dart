import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/monthly_tithes_list_model.dart';
import '../store/monthly_tithes_list_store.dart';

class MonthlyTithesTable extends StatelessWidget {
  const MonthlyTithesTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MonthlyTithesListStore>();
    final state = store.state;
    final grouped = state.data.recordsBySymbol;
    final symbols =
        state.data.orderedSymbols.where(grouped.containsKey).toList();

    if (state.makeRequest) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 40.0),
        child: CircularProgressIndicator(),
      );
    }

    if (state.data.results.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Center(child: Text(context.l10n.reports_monthly_tithes_empty)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          symbols.map((symbol) {
            final rows = grouped[symbol] ?? [];
            if (rows.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (symbols.length > 1) ...[
                    Text(
                      symbol,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomTable(
                      headers: [
                        context.l10n.reports_monthly_tithes_header_date,
                        context.l10n.reports_monthly_tithes_header_amount,
                        context.l10n.reports_monthly_tithes_header_account,
                        context.l10n.reports_monthly_tithes_header_account_type,
                      ],
                      data: FactoryDataTable<MonthlyTithesModel>(
                        data: rows,
                        dataBuilder: monthlyTithesDTO,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  List<dynamic> monthlyTithesDTO(dynamic data) {
    return [
      convertDateFormatToDDMMYYYY(data.date.toString()),
      CurrencyFormatter.formatCurrency(data.amount, symbol: data.symbol),
      data.accountName,
      data.accountType,
    ];
  }
}
