import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:flutter/material.dart';

import '../models/installment_model.dart';

class InstallmentsTable extends StatefulWidget {
  final List<dynamic> installments;
  final Function(List<String> ids) setInstallmentIds;

  const InstallmentsTable({
    super.key,
    required this.installments,
    required this.setInstallmentIds,
  });

  @override
  State<InstallmentsTable> createState() => _InstallmentsTableState();
}

class _InstallmentsTableState extends State<InstallmentsTable> {
  final Map<String?, bool> _selectedInstallments = {};
  final List<String> installmentIds = [];

  @override
  Widget build(BuildContext context) {
    final List<dynamic> headers = [
      // Widget checkbox para la columna de selección
      Checkbox(
        value: _allInstallmentsSelected(),
        onChanged: _toggleAllInstallments,
      ),
      'Parcela',
      'Valor',
      'Data de Vencimento',
      'Estado',
      'Valor Pago',
      'Valor Pendente',
      'Data de Pagamento',
    ];

    return CustomTable(
      headers: headers,
      data: FactoryDataTable(
        data: widget.installments,
        dataBuilder: (installment) {
          final InstallmentModel item = installment as InstallmentModel;

          // La primera columna es un checkbox, el resto son valores de texto
          return [
            // Widget checkbox para seleccionar la parcela
            installment.status == InstallmentsStatus.PAID.apiValue
                ? const Icon(Icons.check, color: AppColors.green)
                : Checkbox(
                  value: _selectedInstallments[item.installmentId] ?? false,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedInstallments[item.installmentId] = value;
                        _setStatedSelectedInstallmentsIds();
                        installmentIds.add(item.installmentId!);
                      });
                    }
                  },
                ),

            'Parcela ${widget.installments.indexOf(item) + 1}',
            formatCurrency(item.amount),
            convertDateFormatToDDMMYYYY(item.dueDate),
            _getStatusWidget(item.status),
            formatCurrency(item.amountPaid ?? 0),
            formatCurrency(item.amountPending ?? 0),
            item.paymentDate != null
                ? convertDateFormatToDDMMYYYY(item.paymentDate as String?)
                : 'N/A',
          ];
        },
      ),
    );
  }

  _setStatedSelectedInstallmentsIds() {
    List ids =
        widget.installments
            .where(
              (installment) =>
                  _selectedInstallments[installment.installmentId] == true,
            )
            .map((installment) => installment.installmentId)
            .toList();

    widget.setInstallmentIds(ids.whereType<String>().toList());
  }

  // Verifica si todas las parcelas están seleccionadas
  bool _allInstallmentsSelected() {
    if (widget.installments.isEmpty) return false;
    return widget.installments
        .where(
          (installment) =>
              installment.status != InstallmentsStatus.PAID.apiValue,
        )
        .every(
          (installment) =>
              _selectedInstallments[installment.installmentId] == true,
        );
  }

  // Alterna la selección de todas las parcelas
  void _toggleAllInstallments(bool? value) {
    if (value == null) return;

    setState(() {
      for (var installment in widget.installments) {
        _selectedInstallments[installment.installmentId] = value;
      }
      _setStatedSelectedInstallmentsIds();
    });
  }

  Widget _getStatusWidget(String? status) {
    if (status == null) return const Text('N/A');

    String statusText;
    Color statusColor;

    switch (status) {
      case 'PAID':
        statusText = InstallmentsStatus.PAID.friendlyName;
        statusColor = AppColors.green;
        break;
      case 'PENDING':
        statusText = InstallmentsStatus.PENDING.friendlyName;
        statusColor = AppColors.mustard;
        break;
      case 'IN_REVIEW':
        statusText = InstallmentsStatus.IN_REVIEW.friendlyName;
        statusColor = AppColors.purple;
        break;
      default:
        statusText = InstallmentsStatus.PARTIAL.friendlyName;
        statusColor = Colors.blue;
    }

    return Text(
      statusText,
      style: TextStyle(color: statusColor, fontFamily: AppFonts.fontSubTitle),
    );
  }
}
