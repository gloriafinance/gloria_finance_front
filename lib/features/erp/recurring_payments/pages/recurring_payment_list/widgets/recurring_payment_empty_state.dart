import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

/// Estado vacío: la iglesia todavía no registró ninguna recurrencia.
///
/// No ofrece "limpar filtros" porque no hay filtros aplicados; la única salida
/// es crear la primera recurrencia.
class RecurringPaymentEmptyState extends StatelessWidget {
  const RecurringPaymentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 34),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 44),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.event_repeat,
              size: 36,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            context.l10n.recurringPayments_empty_title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 19,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              context.l10n.recurringPayments_empty_description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 13.5,
                height: 1.7,
                color: Color(0xFF5F5F5F),
              ),
            ),
          ),
          const SizedBox(height: 26),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: CustomButton(
              text:
                  isMobile(context)
                      ? context.l10n.recurringPayments_empty_cta_short
                      : context.l10n.recurringPayments_empty_cta,
              backgroundColor: AppColors.purple,
              textColor: Colors.white,
              icon: Icons.add,
              onPressed: () => context.go('/recurring-payments/add'),
            ),
          ),
        ],
      ),
    );
  }
}
