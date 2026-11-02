import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_form_store.dart';

/// Acciones del formulario: cancelar y guardar.
///
/// En desktop la acción principal se alinea a la derecha con ancho fijo (patrón
/// del ERP); en mobile las dos acciones ocupan el ancho completo.
class RecurringPaymentFormActions extends StatelessWidget {
  const RecurringPaymentFormActions({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  final Future<void> Function() onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentFormStore>();
    final l10n = context.l10n;

    if (store.state.isLoading) {
      return const Loading();
    }

    // Verde com texto preto é o padrão de "salvar" nos formulários do ERP
    // (banco, centro de custo, usuários, login).
    final saveButton = CustomButton(
      text:
          store.state.isEdit
              ? l10n.recurringPayments_update_action
              : l10n.recurringPayments_save_action,
      backgroundColor: AppColors.green,
      textColor: Colors.black,
      icon: Icons.check,
      onPressed: () => onSave(),
    );

    final cancelButton = ButtonActionTable(
      color: AppColors.grey,
      text: l10n.common_cancel,
      icon: Icons.close,
      onPressed: onCancel,
    );

    if (isMobile(context)) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            Expanded(child: cancelButton),
            const SizedBox(width: 12),
            Expanded(child: saveButton),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.recurringPayments_required_hint,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ),
          cancelButton,
          const SizedBox(width: 12),
          SizedBox(width: 300, child: saveButton),
        ],
      ),
    );
  }
}
