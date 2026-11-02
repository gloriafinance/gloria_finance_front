import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_list_store.dart';

/// Estado "búsqueda sin resultados".
///
/// Distinto del estado vacío: las recurrencias existen, los filtros no devuelven
/// ninguna. Por eso la salida es limpiar filtros y jamás crear una nueva.
class RecurringPaymentNoResultsState extends StatelessWidget {
  const RecurringPaymentNoResultsState({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.read<RecurringPaymentListStore>();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 34),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
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
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.search_off,
              size: 30,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.recurringPayments_no_results_title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.recurringPayments_no_results_description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 13.5,
              height: 1.7,
              color: Color(0xFF5F5F5F),
            ),
          ),
          const SizedBox(height: 20),
          ButtonActionTable(
            color: AppColors.mustard,
            text: context.l10n.common_clear_filters,
            icon: Icons.clear,
            onPressed: store.clearFilters,
          ),
        ],
      ),
    );
  }
}
