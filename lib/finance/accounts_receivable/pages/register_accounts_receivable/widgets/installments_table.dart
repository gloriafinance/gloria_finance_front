import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/helpers/currency_formatter.dart';
import 'package:flutter/material.dart';

import '../../../models/index.dart';

class InstallmentsTable extends StatelessWidget {
  final List<InstallmentModel> installments;
  final Function(int) onRemove;

  const InstallmentsTable({
    super.key,
    required this.installments,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomTable(
        headers: ['Nº', 'Valor', 'Data de Vencimento'],
        data: FactoryDataTable(
          data: installments,
          dataBuilder: (installment) {
            final index = installments.indexOf(installment);
            return [
              '${index + 1}',
              CurrencyFormatter.formatCurrency(installment.amount),
              installment.dueDate,
            ];
          },
        ),
        actionBuilders: [
          (installment) => IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => onRemove(installments.indexOf(installment)),
              ),
        ],
      ),
    );
  }
}
