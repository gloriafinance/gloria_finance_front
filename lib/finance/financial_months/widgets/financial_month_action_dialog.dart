import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/finance/financial_months/models/financial_month_model.dart';
import 'package:flutter/material.dart';

class FinancialMonthActionContent extends StatefulWidget {
  final FinancialMonthModel month;
  final bool isClosing;
  final Future<bool> Function() onConfirm;

  const FinancialMonthActionContent({
    super.key,
    required this.month,
    required this.isClosing,
    required this.onConfirm,
  });

  @override
  State<FinancialMonthActionContent> createState() =>
      _FinancialMonthActionContentState();
}

class _FinancialMonthActionContentState
    extends State<FinancialMonthActionContent> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final actionText = widget.isClosing ? 'fechar' : 'reabrir';
    final iconData =
        widget.isClosing ? Icons.lock_outlined : Icons.lock_open_outlined;
    final iconColor = widget.isClosing ? AppColors.green : AppColors.mustard;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          color: iconColor,
          size: 48,
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
    );
  }

  Future<void> _handleConfirm() async {
    setState(() {
      _isLoading = true;
    });
    final success = await widget.onConfirm();
    if (mounted) {
      Navigator.of(context).pop(success);
    }
  }
}
