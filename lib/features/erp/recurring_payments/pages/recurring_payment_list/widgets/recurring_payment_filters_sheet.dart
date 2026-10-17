import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_list_store.dart';
import 'recurring_payment_filter_fields.dart';

/// Bottom sheet de filtros para mobile.
///
/// Mantiene los tres filtros accesibles sin comprimir la fila de búsqueda, y aplica o
/// limpia con acciones de ancho completo.
Future<void> showRecurringPaymentFiltersSheet(BuildContext context) {
  final store = context.read<RecurringPaymentListStore>();

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder:
        (sheetContext) =>
            ChangeNotifierProvider<RecurringPaymentListStore>.value(
              value: store,
              child: const RecurringPaymentFiltersSheet(),
            ),
  );
}

class RecurringPaymentFiltersSheet extends StatelessWidget {
  const RecurringPaymentFiltersSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentListStore>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.greyMiddle,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            context.l10n.recurringPayments_filter_sheet_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
            ),
          ),
          const RecurringPaymentSearchField(),
          RecurringPaymentStatusField(),
          RecurringPaymentTypeField(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ButtonActionTable(
                  color: AppColors.mustard,
                  text: context.l10n.common_clear_filters,
                  icon: Icons.clear,
                  onPressed: () {
                    store.clearFilters();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ButtonActionTable(
                  color: AppColors.purple,
                  text: context.l10n.common_apply_filters,
                  icon: Icons.search,
                  onPressed: () {
                    store.applyFilters();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
