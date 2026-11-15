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
import 'recurring_payment_form_validators.dart';
import 'recurring_payment_switch_row.dart';
import 'recurring_payment_type_selector.dart';

/// Sección "Configuração da recorrência": tipo de valor, valor, día de
/// vencimiento y estado.
///
/// El tipo manda: con "Valor fixo" el monto es obligatorio; con "Valor variável"
/// el campo desaparece y se explica que el monto se informa cada mes.
class RecurringPaymentConfigSection extends StatelessWidget {
  const RecurringPaymentConfigSection({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentFormStore>();
    final state = store.state;
    final l10n = context.l10n;
    final isFixed = state.isFixed;

    return SectionCard(
      index: 2,
      title: l10n.recurringPayments_section_config_title,
      subtitle: l10n.recurringPayments_section_config_subtitle,
      children: [
        Text(
          l10n.recurringPayments_field_type.toUpperCase(),
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 15,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 10),
        // Si la API devolvió un tipo que este cliente no conoce, nada queda
        // seleccionado y el formulario exige elegir antes de guardar: nunca se
        // sobrescribe la configuración con un tipo inventado.
        FormField<RecurringPaymentValueType?>(
          initialValue: state.type,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator:
              (value) =>
                  value == null
                      ? l10n.recurringPayments_error_type_required
                      : null,
          builder:
              (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RecurringPaymentTypeSelector(
                    selected: state.type,
                    onChanged: (value) {
                      store.setType(value);
                      field.didChange(value);
                    },
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        field.errorText ?? '',
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
        ),
        if (!isFixed) ...[
          const SizedBox(height: 18),
          _VariableAmountNote(
            text: l10n.recurringPayments_variable_amount_note,
          ),
        ],
        if (isFixed)
          _AmountAndDueDayRow(
            amountField: _amountField(context, store),
            dueDayField: _dueDayField(context, store),
          )
        else
          _dueDayField(context, store),
        // A situação só aparece na edição: uma recorrência nova nasce ativa, então
        // um switch aqui seria uma decisão sem consequência prática. Pausar e
        // retomar continua disponível neste formulário e também na listagem.
        if (state.isEdit) ...[
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: Text(
              l10n.recurringPayments_field_status.toUpperCase(),
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 15,
                color: AppColors.purple,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Estado desconocido: no se muestra un switch (no habría valor que
          // alternar). El payload omite `status` y el backend conserva el actual.
          if (!state.hasKnownStatus)
            Text(
              l10n.recurringPayments_status_unknown_note,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 12,
                height: 1.6,
                color: AppColors.grey,
              ),
            )
          else
            RecurringPaymentSwitchRow(
              value: state.status!.isActive,
              title: state.status!.friendlyName(l10n),
              description:
                  state.status!.isActive
                      ? l10n.recurringPayments_status_active_description
                      : l10n.recurringPayments_status_inactive_description,
              onChanged:
                  (isActive) => store.setStatus(
                    isActive
                        ? RecurringPaymentStatus.ACTIVE
                        : RecurringPaymentStatus.INACTIVE,
                  ),
            ),
        ] else
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              l10n.recurringPayments_status_create_note,
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
  }

  Widget _amountField(BuildContext context, RecurringPaymentFormStore store) {
    final l10n = context.l10n;
    final symbol = store.state.symbolFormatMoney;

    return Input(
      label: l10n.recurringPayments_field_amount_with_symbol(symbol),
      initialValue:
          store.state.amountText.isEmpty ? null : store.state.amountText,
      keyboardType: TextInputType.number,
      inputFormatters: [CurrencyFormatter.getInputFormatters(symbol)],
      icon: Icons.attach_money,
      onValidator:
          (value) =>
              amountValidator(context, value, isRequired: store.state.isFixed),
      onChanged: (value) {
        final hasDigits = value.replaceAll(RegExp(r'[^0-9]'), '').isNotEmpty;
        store.setAmount(
          hasDigits ? CurrencyFormatter.cleanCurrency(value) : 0,
          value,
        );
      },
    );
  }

  Widget _dueDayField(BuildContext context, RecurringPaymentFormStore store) {
    final l10n = context.l10n;
    final state = store.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dropdown(
          label: l10n.recurringPayments_field_due_day,
          items: List.generate(31, (index) => '${index + 1}'),
          initialValue: state.dayOfMonth?.toString(),
          searchHint: l10n.recurringPayments_field_due_day,
          onValidator: (value) => dueDayValidator(context, value),
          onChanged: (value) => store.setDayOfMonth(int.tryParse(value)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 6),
          child: Text(
            l10n.recurringPayments_helper_due_day,
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
  }
}

class _AmountAndDueDayRow extends StatelessWidget {
  const _AmountAndDueDayRow({
    required this.amountField,
    required this.dueDayField,
  });

  final Widget amountField;
  final Widget dueDayField;

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [amountField, dueDayField],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: amountField),
        const SizedBox(width: 24),
        Expanded(child: dueDayField),
      ],
    );
  }
}

class _VariableAmountNote extends StatelessWidget {
  const _VariableAmountNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.purple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 12.5,
                height: 1.6,
                color: Color(0xFF5F5F5F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
