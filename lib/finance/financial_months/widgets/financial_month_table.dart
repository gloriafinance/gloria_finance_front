import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:church_finance_bk/finance/financial_months/models/financial_month_model.dart';
import 'package:church_finance_bk/finance/financial_months/store/financial_month_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'financial_month_action_dialog.dart';

class FinancialMonthTable extends StatelessWidget {
  const FinancialMonthTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<FinancialMonthStore>();
    final state = store.state;

    if (state.isLoading) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 40.0),
        child: const CircularProgressIndicator(),
      );
    }

    if (state.months.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: const Center(
          child: Text(
            'Nenhum mês financeiro encontrado.',
            style: TextStyle(fontFamily: AppFonts.fontText),
          ),
        ),
      );
    }

    return CustomTable(
      headers: const [
        'Mês',
        'Ano',
        'Status',
      ],
      data: FactoryDataTable<FinancialMonthModel>(
        data: state.months,
        dataBuilder: (month) => _mapToRow(month),
      ),
      actionBuilders: [
        (month) => _buildActionButton(context, month as FinancialMonthModel),
      ],
    );
  }

  List<dynamic> _mapToRow(FinancialMonthModel month) {
    return [
      month.monthName,
      month.year.toString(),
      month.closed
          ? tagStatus(AppColors.green, 'Fechado')
          : tagStatus(AppColors.mustard, 'Aberto'),
    ];
  }

  Widget _buildActionButton(BuildContext context, FinancialMonthModel month) {
    if (month.closed) {
      return ButtonActionTable(
        color: AppColors.mustard,
        text: 'Reabrir',
        onPressed: () => _showActionDialog(context, month, false),
        icon: Icons.lock_open_outlined,
      );
    } else {
      return ButtonActionTable(
        color: AppColors.green,
        text: 'Fechar',
        onPressed: () => _showActionDialog(context, month, true),
        icon: Icons.lock_outlined,
      );
    }
  }

  void _showActionDialog(
    BuildContext context,
    FinancialMonthModel month,
    bool isClosing,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => FinancialMonthActionDialog(
        month: month,
        isClosing: isClosing,
        onConfirm: () async {
          final store = context.read<FinancialMonthStore>();
          bool success;
          if (isClosing) {
            success = await store.closeMonth(month.month, month.year);
          } else {
            success = await store.openMonth(month.month, month.year);
          }
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop(success);
          }
        },
      ),
    );
  }
}
