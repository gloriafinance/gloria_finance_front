import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/section_card.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_form_store.dart';
import '../../../store/recurring_payment_options_store.dart';
import 'recurring_payment_form_validators.dart';

/// Sección "Informações básicas": nombre, concepto financiero y centro de costo.
///
/// El centro de costo es obligatorio en el modelo (todo gasto se imputa), así
/// que vive aquí y no escondido en una sección avanzada.
class RecurringPaymentBasicSection extends StatelessWidget {
  const RecurringPaymentBasicSection({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentFormStore>();
    final state = store.state;
    final l10n = context.l10n;

    // El store de opciones ya trae, por contrato, solo conceptos de gasto (OUTGO)
    // activos y centros de costo activos.
    final options = context.watch<RecurringPaymentOptionsStore>().state;
    final concepts = options.expenseConcepts;
    final costCenters = options.costCenters;

    final conceptNames = {
      for (final concept in concepts) concept.financialConceptId: concept.name,
    };
    final costCenterNames = {
      for (final costCenter in costCenters)
        costCenter.costCenterId: costCenter.name,
    };

    final conceptField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dropdown(
          label: l10n.recurringPayments_field_concept,
          items: conceptNames.keys.toList(),
          enabled: conceptNames.isNotEmpty,
          initialValue:
              conceptNames.containsKey(state.financialConceptId)
                  ? state.financialConceptId
                  : null,
          itemLabelBuilder: (id) => conceptNames[id] ?? id,
          onValidator:
              (value) => selectionValidator(
                context,
                value,
                l10n.recurringPayments_error_concept_required,
              ),
          onChanged: store.setFinancialConceptId,
        ),
        if (conceptNames.isEmpty)
          _MissingOptions(message: l10n.recurringPayments_error_no_concepts),
      ],
    );

    final costCenterField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dropdown(
          label: l10n.recurringPayments_field_cost_center,
          items: costCenterNames.keys.toList(),
          enabled: costCenterNames.isNotEmpty,
          initialValue:
              costCenterNames.containsKey(state.costCenterId)
                  ? state.costCenterId
                  : null,
          itemLabelBuilder: (id) => costCenterNames[id] ?? id,
          onValidator:
              (value) => selectionValidator(
                context,
                value,
                l10n.recurringPayments_error_cost_center_required,
              ),
          onChanged: store.setCostCenterId,
        ),
        if (costCenterNames.isEmpty)
          _MissingOptions(
            message: l10n.recurringPayments_error_no_cost_centers,
          ),
      ],
    );

    return SectionCard(
      index: 1,
      title: l10n.recurringPayments_section_basic_title,
      subtitle: l10n.recurringPayments_section_basic_subtitle,
      children: [
        Input(
          label: l10n.recurringPayments_field_name,
          initialValue: state.name,
          onValidator: (value) => nameValidator(context, value),
          onChanged: store.setName,
        ),
        _Helper(text: l10n.recurringPayments_helper_name),
        if (isMobile(context))
          Column(
            children: [
              conceptField,
              _Helper(text: l10n.recurringPayments_helper_concept),
              costCenterField,
              _Helper(text: l10n.recurringPayments_helper_cost_center),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    conceptField,
                    _Helper(text: l10n.recurringPayments_helper_concept),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    costCenterField,
                    _Helper(text: l10n.recurringPayments_helper_cost_center),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _Helper extends StatelessWidget {
  const _Helper({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppFonts.fontText,
          fontSize: 12,
          height: 1.6,
          color: AppColors.grey,
        ),
      ),
    );
  }
}

class _MissingOptions extends StatelessWidget {
  const _MissingOptions({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        message,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 13.5,
          color: Color(0xFF8A5A00),
        ),
      ),
    );
  }
}
