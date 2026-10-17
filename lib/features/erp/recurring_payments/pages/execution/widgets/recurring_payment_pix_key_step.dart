import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_model.dart';
import '../../../store/recurring_payment_execution_store.dart';
import '../../../utils/recurring_payment_pix_input.dart';

/// Chave PIX da execução.
///
/// Só aparece quando a recorrência **não** guarda um destino: se guarda, a chave
/// é herdada e não se pergunta de novo.
class RecurringPaymentPixKeyStep extends StatelessWidget {
  const RecurringPaymentPixKeyStep({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentExecutionStore>();
    final state = store.state;
    final l10n = context.l10n;
    final keyType = state.pixKeyType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Dropdown(
          label: l10n.recurringPaymentsExecution_pix_key_type_label,
          items: PixKeyTypeExtension.listApiValues,
          initialValue: keyType?.apiValue,
          searchHint: l10n.recurringPaymentsExecution_pix_key_type_label,
          onChanged: (value) {
            final parsed = PixKeyTypeExtension.tryFromApiValue(value);
            if (parsed != null) store.setPixKeyType(parsed);
          },
        ),
        const SizedBox(height: 16),
        Input(
          label: l10n.recurringPaymentsExecution_pix_key_label,
          hintText: l10n.recurringPaymentsExecution_pix_key_hint,
          initialValue: state.pixKey.isEmpty ? null : state.pixKey,
          icon: Icons.vpn_key_outlined,
          iconRight: const Icon(Icons.content_paste_outlined),
          onIconTap: () => _pastePixKey(context),
          keyboardType:
              keyType == null
                  ? TextInputType.text
                  : pixKeyKeyboardType(keyType),
          inputFormatters:
              keyType == null ? const [] : pixKeyInputFormatters(keyType),
          maxLines: state.pixKey.length > 55 ? 4 : 1,
          onChanged: store.setPixKey,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: l10n.recurringPaymentsExecution_confirm_action,
          backgroundColor: AppColors.purple,
          textColor: Colors.white,
          icon: Icons.arrow_forward,
          onPressed:
              state.pixKey.trim().isEmpty || state.pixKeyType == null
                  ? null
                  : onContinue,
        ),
      ],
    );
  }

  Future<void> _pastePixKey(BuildContext context) async {
    final store = context.read<RecurringPaymentExecutionStore>();
    final value = await Clipboard.getData(Clipboard.kTextPlain);
    final text = value?.text;
    if (text == null || text.isEmpty) return;
    store.setPixKey(text);
  }
}
