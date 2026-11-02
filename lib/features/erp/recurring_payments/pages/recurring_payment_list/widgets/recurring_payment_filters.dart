import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_list_store.dart';
import 'recurring_payment_filter_fields.dart';
import 'recurring_payment_filters_sheet.dart';

/// Barra de filtros de la listado.
///
/// Desktop/tablet: búsqueda + estado + tipo en la misma fila, con "Limpar filtros" y
/// "Aplicar filtros" (mismo patrón de las otras listas del ERP). Mobile: solo la búsqueda
/// queda visible y los demás filtros van a un bottom sheet.
class RecurringPaymentFilters extends StatelessWidget {
  const RecurringPaymentFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentListStore>();

    if (!store.state.hasPayments) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child:
          isMobile(context)
              ? _mobileFilters(context)
              : _desktopFilters(context, store),
    );
  }

  Widget _mobileFilters(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: RecurringPaymentSearchField()),
        const SizedBox(width: 12),
        ButtonActionTable(
          color: AppColors.blue,
          text: context.l10n.recurringPayments_filter_open_action,
          onPressed: () => showRecurringPaymentFiltersSheet(context),
          icon: Icons.tune,
        ),
      ],
    );
  }

  Widget _desktopFilters(
    BuildContext context,
    RecurringPaymentListStore store,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: RecurringPaymentSearchField()),
            const SizedBox(width: 16),
            Expanded(child: RecurringPaymentStatusField()),
            const SizedBox(width: 16),
            Expanded(child: RecurringPaymentTypeField()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonActionTable(
              icon: Icons.clear,
              color: AppColors.mustard,
              text: context.l10n.common_clear_filters,
              onPressed: store.clearFilters,
            ),
            const SizedBox(width: 12),
            ButtonActionTable(
              color: AppColors.blue,
              text: context.l10n.common_apply_filters,
              icon: Icons.search,
              onPressed: store.applyFilters,
            ),
          ],
        ),
        const RecurringPaymentFilterResultCount(),
      ],
    );
  }
}
