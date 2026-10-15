import 'package:flutter/material.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_form_store.dart';
import '../../../store/recurring_payment_list_store.dart';
import 'recurring_payment_basic_section.dart';
import 'recurring_payment_config_section.dart';
import 'recurring_payment_form_actions.dart';
import 'recurring_payment_pix_section.dart';

/// Cuerpo del formulario: valida, guarda y compone las tres secciones.
class RecurringPaymentFormBody extends StatefulWidget {
  const RecurringPaymentFormBody({super.key});

  @override
  State<RecurringPaymentFormBody> createState() =>
      _RecurringPaymentFormBodyState();
}

class _RecurringPaymentFormBodyState extends State<RecurringPaymentFormBody> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecurringPaymentFormStore>().state;

    // El formulario se abrió solo con el id (deep link) y todavía no tiene
    // datos: se muestra el cargando en lugar de un formulario vacío.
    final isHydrating = state.isLoading && !state.isEdit && state.name.isEmpty;
    if (isHydrating) {
      return const Loading();
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RecurringPaymentBasicSection(),
          const SizedBox(height: 18),
          const RecurringPaymentConfigSection(),
          const SizedBox(height: 18),
          const RecurringPaymentPixSection(),
          const SizedBox(height: 18),
          RecurringPaymentFormActions(
            onSave: _save,
            onCancel: () => context.go('/recurring-payments'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final store = context.read<RecurringPaymentFormStore>();
    final listStore = context.read<RecurringPaymentListStore>();
    final isEdit = store.state.isEdit;
    final l10n = context.l10n;

    final success = await store.submit();

    if (!mounted) return;

    if (!success) {
      Toast.showMessage(
        l10n.recurringPayments_toast_save_error,
        ToastType.warning,
      );
      return;
    }

    Toast.showMessage(
      isEdit
          ? l10n.recurringPayments_toast_updated
          : l10n.recurringPayments_toast_saved,
      ToastType.info,
    );

    await listStore.searchRecurringPayments();

    if (!mounted) return;
    context.go('/recurring-payments');
  }
}
