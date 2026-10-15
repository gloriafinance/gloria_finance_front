import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/open_gloria_assistance_context_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_model.dart';
import '../../../store/recurring_payment_form_store.dart';
import '../../../store/recurring_payment_options_store.dart';
import 'recurring_payment_form_body.dart';

/// Cuerpo navegable del formulario: título, ayuda contextual y secciones.
///
/// Se separa de la pantalla para que no dependa de la sesión y pueda renderizarse
/// en pruebas de widget con el símbolo de moneda inyectado.
class RecurringPaymentFormView extends StatefulWidget {
  const RecurringPaymentFormView({
    super.key,
    required this.symbolFormatMoney,
    this.recurringPayment,
    this.recurringPaymentId,
  });

  final String symbolFormatMoney;
  final RecurringPaymentModel? recurringPayment;
  final String? recurringPaymentId;

  @override
  State<RecurringPaymentFormView> createState() =>
      _RecurringPaymentFormViewState();
}

class _RecurringPaymentFormViewState extends State<RecurringPaymentFormView> {
  @override
  void initState() {
    super.initState();
    // Con deep link el formulario se abre sin pasar por el listado: se asegura
    // aquí que los conceptos de gasto y los centros de costo estén cargados.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final optionsStore = context.read<RecurringPaymentOptionsStore>();
      if (await optionsStore.needsLoad()) {
        await optionsStore.searchOptions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    final isEdit =
        widget.recurringPayment != null ||
        (widget.recurringPaymentId?.isNotEmpty ?? false);
    final title =
        isEdit
            ? context.l10n.recurringPayments_form_title_edit
            : context.l10n.recurringPayments_form_title_create;

    return ChangeNotifierProvider(
      create:
          (_) => RecurringPaymentFormStore(
            recurringPayment: widget.recurringPayment,
            recurringPaymentId: widget.recurringPaymentId,
            symbolFormatMoney: widget.symbolFormatMoney,
          )..initialize(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go('/recurring-payments'),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OpenGloriaAssistanceContextButton(
            question:
                context
                    .l10n
                    .support_assistant_context_recurring_payment_question,
            title: title,
            route: '/recurring-payments/add',
            module: 'finance_configuration',
            summary:
                'Screen used to configure a permanent monthly commitment (rent, utilities, missions) without executing any payment.',
            relatedRoutes: const [
              '/recurring-payments',
              '/accounts-payable/list',
              '/financial-concepts',
              '/cost-center',
            ],
            extraData: {'mode': isEdit ? 'edit' : 'create'},
          ),
          const SizedBox(height: 12),
          const RecurringPaymentFormBody(),
        ],
      ),
    );
  }
}
