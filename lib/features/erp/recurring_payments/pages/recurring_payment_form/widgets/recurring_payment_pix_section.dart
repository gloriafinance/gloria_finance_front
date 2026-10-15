import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/section_card.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_model.dart';
import '../../../store/recurring_payment_form_store.dart';
import '../../../utils/recurring_payment_pix_input.dart';
import 'recurring_payment_form_validators.dart';
import 'recurring_payment_switch_row.dart';

/// Sección "PIX reutilizável", deliberadamente opcional.
///
/// Guarda un destino que podrá reaprovecharse cuando la iglesia ejecute pagos
/// por el banco. No es un método de pago: no define cómo se paga la
/// recurrencia, y la recurrencia sigue siendo válida sin esta sección.
class RecurringPaymentPixSection extends StatelessWidget {
  const RecurringPaymentPixSection({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentFormStore>();
    final state = store.state;
    final l10n = context.l10n;

    return SectionCard(
      index: 3,
      borderColor:
          state.pixEnabled
              ? AppColors.blue.withValues(alpha: 0.4)
              : AppColors.greyMiddle,
      title: l10n.recurringPayments_section_pix_title,
      titleSuffix: _OptionalBadge(label: l10n.recurringPayments_optional_badge),
      subtitle: l10n.recurringPayments_section_pix_subtitle,
      children: [
        RecurringPaymentSwitchRow(
          value: state.pixEnabled,
          title: l10n.recurringPayments_pix_toggle_label,
          description: l10n.recurringPayments_pix_toggle_description,
          onChanged: store.setPixEnabled,
        ),
        if (state.pixEnabled) _pixFields(context, store),
      ],
    );
  }

  Widget _pixFields(BuildContext context, RecurringPaymentFormStore store) {
    final l10n = context.l10n;
    final state = store.state;

    // A chave depende do tipo: a máscara e o teclado acompanham a seleção.
    final keyField = Input(
      label: l10n.recurringPayments_field_pix_key,
      initialValue: state.pixKey.isEmpty ? null : state.pixKey,
      icon: Icons.vpn_key_outlined,
      keyboardType: pixKeyKeyboardType(state.pixKeyType),
      inputFormatters: pixKeyInputFormatters(state.pixKeyType),
      onValidator: (value) => pixKeyValidator(context, value, isRequired: true),
      onChanged: store.setPixKey,
    );

    final typeField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dropdown(
          label: l10n.recurringPayments_field_pix_key_type,
          items: PixKeyTypeExtension.listApiValues,
          initialValue: state.pixKeyType.apiValue,
          searchHint: l10n.recurringPayments_field_pix_key_type,
          onChanged:
              (value) =>
                  store.setPixKeyType(PixKeyTypeExtension.fromApiValue(value)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 6),
          child: Text(
            l10n.recurringPayments_helper_pix_key_type,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 12,
              height: 1.6,
              color: AppColors.grey,
            ),
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.blue.withValues(alpha: 0.06),
          border: Border.all(color: AppColors.blue.withValues(alpha: 0.28)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.pix, size: 16, color: Color(0xFF1268AD)),
                const SizedBox(width: 8),
                Text(
                  l10n.recurringPayments_pix_panel_title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 13,
                    color: Color(0xFF1268AD),
                  ),
                ),
              ],
            ),
            if (isMobile(context)) ...[
              typeField,
              keyField,
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: typeField),
                  const SizedBox(width: 24),
                  Expanded(child: keyField),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 8, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Color(0xFF1268AD),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.recurringPayments_helper_pix,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 12,
                        height: 1.6,
                        color: Color(0xFF5F5F5F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionalBadge extends StatelessWidget {
  const _OptionalBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 10.5,
          color: AppColors.grey,
        ),
      ),
    );
  }
}
