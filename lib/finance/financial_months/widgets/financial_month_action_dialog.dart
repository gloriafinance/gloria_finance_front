import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/finance/financial_months/models/financial_month_model.dart';
import 'package:flutter/material.dart';

class FinancialMonthActionDialog extends StatefulWidget {
  final FinancialMonthModel month;
  final bool isClosing;
  final Future<void> Function() onConfirm;

  const FinancialMonthActionDialog({
    super.key,
    required this.month,
    required this.isClosing,
    required this.onConfirm,
  });

  @override
  State<FinancialMonthActionDialog> createState() =>
      _FinancialMonthActionDialogState();
}

class _FinancialMonthActionDialogState
    extends State<FinancialMonthActionDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final actionText = widget.isClosing ? 'fechar' : 'reabrir';
    final title = widget.isClosing ? 'Fechar Mês' : 'Reabrir Mês';
    final iconData = widget.isClosing ? Icons.lock_outlined : Icons.lock_open_outlined;
    final iconColor = widget.isClosing ? AppColors.green : AppColors.mustard;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                color: iconColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                  fontFamily: AppFonts.fontTitle,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Deseja $actionText o mês de ${widget.month.monthName} de ${widget.month.year}?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: AppFonts.fontText,
                ),
              ),
              if (widget.isClosing) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.purple, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ao fechar o mês, não será possível realizar lançamentos neste período.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontFamily: AppFonts.fontText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonActionTable(
                      text: 'Cancelar',
                      color: Colors.black38,
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: Icons.close,
                    ),
                    const SizedBox(width: 12),
                    ButtonActionTable(
                      text: 'Confirmar',
                      icon: Icons.check,
                      color: iconColor,
                      onPressed: _handleConfirm,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleConfirm() async {
    setState(() {
      _isLoading = true;
    });
    await widget.onConfirm();
  }
}
