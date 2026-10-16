import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/general.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

/// Mês sem compromissos: nada vence nesta competência.
class RecurringPaymentMonthlyEmptyState extends StatelessWidget {
  const RecurringPaymentMonthlyEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isCompact = isMobile(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.event_available,
              size: 30,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.recurringPaymentsExecution_empty_title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.recurringPaymentsExecution_empty_description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 13.5,
              height: 1.7,
              color: Color(0xFF5F5F5F),
            ),
          ),
          const SizedBox(height: 22),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: CustomButton(
              text: l10n.recurringPaymentsExecution_empty_action,
              backgroundColor: AppColors.purple,
              textColor: Colors.white,
              icon: isCompact ? null : Icons.tune,
              onPressed: () => context.go('/recurring-payments/configuration'),
            ),
          ),
        ],
      ),
    );
  }
}
