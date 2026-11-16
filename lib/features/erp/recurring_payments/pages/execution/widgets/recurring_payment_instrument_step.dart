import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';

class RecurringPaymentInstrumentStep extends StatelessWidget {
  const RecurringPaymentInstrumentStep({
    super.key,
    required this.hasConfiguredPix,
    required this.isVariable,
    required this.amountText,
    required this.symbolFormatMoney,
    required this.pixKey,
    required this.canUseConfiguredPix,
    required this.onAmountChanged,
    required this.onConfiguredPix,
    required this.onBoleto,
    required this.onPixQr,
  });

  final bool hasConfiguredPix;
  final bool isVariable;
  final String amountText;
  final String symbolFormatMoney;
  final String? pixKey;
  final bool canUseConfiguredPix;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onConfiguredPix;
  final VoidCallback onBoleto;
  final VoidCallback onPixQr;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isVariable && hasConfiguredPix) ...[
          Input(
            label: l10n.recurringPaymentsExecution_manual_amount_label,
            initialValue: amountText.isEmpty ? null : amountText,
            keyboardType: TextInputType.number,
            inputFormatters: [
              CurrencyFormatter.getInputFormatters(symbolFormatMoney),
            ],
            icon: Icons.attach_money,
            onChanged: onAmountChanged,
          ),
          const SizedBox(height: 12),
        ],
        if (hasConfiguredPix) ...[
          _InstrumentCard(
            icon: Icons.bolt_outlined,
            title: l10n.recurringPaymentsExecution_pix_destination_label,
            subtitle: pixKey ?? '',
            onTap: canUseConfiguredPix ? onConfiguredPix : null,
          ),
          const SizedBox(height: 10),
        ],
        _InstrumentCard(
          icon: Icons.qr_code_2,
          title: l10n.recurringPaymentsExecution_instrument_qr,
          subtitle: l10n.recurringPaymentsExecution_instrument_qr_hint,
          onTap: onPixQr,
        ),
        const SizedBox(height: 10),
        _InstrumentCard(
          icon: Icons.receipt_long_outlined,
          title: l10n.recurringPaymentsExecution_instrument_boleto,
          subtitle: l10n.recurringPaymentsExecution_instrument_boleto_hint,
          onTap: onBoleto,
        ),
      ],
    );
  }
}

class _InstrumentCard extends StatelessWidget {
  const _InstrumentCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE4E7EC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
            color: onTap == null ? AppColors.grey : AppColors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: onTap == null ? AppColors.grey : Color(0xFF242126),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 11.5,
                    color: onTap == null ? AppColors.grey : Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: onTap == null ? AppColors.grey : null,
          ),
        ],
      ),
    ),
  );
}
