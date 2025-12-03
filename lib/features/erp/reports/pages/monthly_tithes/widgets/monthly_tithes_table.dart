import 'package:church_finance_bk/core/paginate/custom_table.dart';
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
        child: Center(
          child: Text(context.l10n.reports_monthly_tithes_empty),
        ),
      );
    }

    return CustomTable(
      headers: [
        context.l10n.reports_monthly_tithes_header_date,
        context.l10n.reports_monthly_tithes_header_amount,
        context.l10n.reports_monthly_tithes_header_account,
        context.l10n.reports_monthly_tithes_header_account_type,
      ],
      data: FactoryDataTable<MonthlyTithesModel>(
        data: state.data.results,
        dataBuilder: monthlyTithesDTO,
      ),
    );
  }

  List<dynamic> monthlyTithesDTO(dynamic data) {
    return [
      convertDateFormatToDDMMYYYY(data.date.toString()),
      CurrencyFormatter.formatCurrency(data.amount),
      data.accountName,
      data.accountType,
    ];
  }
}
