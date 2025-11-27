import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/financial_month_model.dart';
import '../store/financial_month_store.dart';
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
      headers: const ['Mês', 'Ano', 'Status'],
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
        onPressed: () => _showActionModal(context, month, false),
        icon: Icons.lock_open_outlined,
      );
    } else {
      return ButtonActionTable(
        color: AppColors.green,
        text: 'Fechar',
        onPressed: () => _showActionModal(context, month, true),
        icon: Icons.lock_outlined,
      );
    }
  }

  void _showActionModal(
    BuildContext context,
    FinancialMonthModel month,
    bool isClosing,
  ) {
    final store = context.read<FinancialMonthStore>();
    final title = isClosing ? 'Fechar Mês' : 'Reabrir Mês';

    ModalPage(
      title: title,
      width: 450,
      body: FinancialMonthActionContent(
        month: month,
        isClosing: isClosing,
        onConfirm: () async {
          if (isClosing) {
            return await store.closeMonth(month.month, month.year);
          } else {
            return await store.openMonth(month.month, month.year);
          }
        },
      ),
    ).show(context);
  }
}
