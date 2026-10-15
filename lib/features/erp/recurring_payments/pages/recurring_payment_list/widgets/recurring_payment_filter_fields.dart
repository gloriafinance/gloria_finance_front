import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_model.dart';
import '../../../store/recurring_payment_list_store.dart';

/// Campos de filtro compartidos por la barra (desktop/tablet) y el bottom
/// sheet (mobile). Cada campo habla directo con el store de la listado.
class RecurringPaymentSearchField extends StatelessWidget {
  const RecurringPaymentSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentListStore>();

    return Input(
      label: context.l10n.recurringPayments_filter_search_label,
      // Atado al filtro del store: cuando "Limpar filtros" vacía el término, el
      // campo también se vacía (antes quedaba con el texto viejo visible).
      initialValue: store.state.filters.searchTerm,
      onChanged: store.setSearchTerm,
      icon: Icons.search,
    );
  }
}

class RecurringPaymentStatusField extends StatelessWidget {
  const RecurringPaymentStatusField({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final store = context.watch<RecurringPaymentListStore>();
    final selected = store.state.filters.status;

    final items = [
      l10n.recurringPayments_filter_all,
      l10n.settings_church_profile_status_active,
      l10n.settings_church_profile_status_inactive,
    ];

    return Dropdown(
      label: l10n.recurringPayments_filter_status_label,
      items: items,
      searchHint: l10n.recurringPayments_filter_status_label,
      initialValue: _statusLabel(selected, l10n),
      onChanged:
          (value) => store.setStatusFilter(_statusFromLabel(value, l10n)),
      labelSuffix: _ClearFilterButton(
        visible: selected != null,
        onPressed: () => store.setStatusFilter(null),
      ),
    );
  }

  String _statusLabel(RecurringPaymentStatus? status, AppLocalizations l10n) {
    if (status == null) return l10n.recurringPayments_filter_all;
    return status.friendlyName(l10n);
  }

  RecurringPaymentStatus? _statusFromLabel(
    String label,
    AppLocalizations l10n,
  ) {
    if (label == l10n.recurringPayments_filter_all) return null;
    if (label == l10n.settings_church_profile_status_active) {
      return RecurringPaymentStatus.ACTIVE;
    }
    return RecurringPaymentStatus.INACTIVE;
  }
}

class RecurringPaymentTypeField extends StatelessWidget {
  const RecurringPaymentTypeField({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final store = context.watch<RecurringPaymentListStore>();
    final selected = store.state.filters.type;

    final items = [
      l10n.recurringPayments_filter_all,
      RecurringPaymentValueType.FIXED.friendlyName(l10n),
      RecurringPaymentValueType.VARIABLE.friendlyName(l10n),
    ];

    return Dropdown(
      label: l10n.recurringPayments_filter_type_label,
      items: items,
      searchHint: l10n.recurringPayments_filter_type_label,
      initialValue:
          selected?.friendlyName(l10n) ?? l10n.recurringPayments_filter_all,
      onChanged: (value) => store.setTypeFilter(_typeFromLabel(value, l10n)),
      labelSuffix: _ClearFilterButton(
        visible: selected != null,
        onPressed: () => store.setTypeFilter(null),
      ),
    );
  }

  RecurringPaymentValueType? _typeFromLabel(
    String label,
    AppLocalizations l10n,
  ) {
    if (label == l10n.recurringPayments_filter_all) return null;
    if (label == RecurringPaymentValueType.FIXED.friendlyName(l10n)) {
      return RecurringPaymentValueType.FIXED;
    }
    return RecurringPaymentValueType.VARIABLE;
  }
}

class _ClearFilterButton extends StatelessWidget {
  const _ClearFilterButton({required this.visible, required this.onPressed});

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onPressed,
      child: const Icon(Icons.close, size: 18, color: AppColors.greyMiddle),
    );
  }
}

/// Texto auxiliar con el conteo mostrado cuando hay filtros aplicados.
class RecurringPaymentFilterResultCount extends StatelessWidget {
  const RecurringPaymentFilterResultCount({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecurringPaymentListStore>().state;

    if (state.appliedFilters.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Text(
        context.l10n.recurringPayments_filter_result_count(
          state.visiblePayments.length,
          state.totalCount,
        ),
        style: const TextStyle(
          fontFamily: AppFonts.fontText,
          fontSize: 12.5,
          color: AppColors.grey,
        ),
      ),
    );
  }
}
