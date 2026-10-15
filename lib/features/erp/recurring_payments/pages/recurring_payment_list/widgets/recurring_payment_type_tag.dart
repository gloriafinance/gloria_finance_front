import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

import '../../../models/recurring_payment_model.dart';
import 'recurring_payment_pill.dart';

/// Etiqueta del tipo de valor de la recurrencia.
///
/// Usa fondo suave (no el `tagStatus` sólido) porque la fila ya tiene una
/// etiqueta de estado con color; dos bloques sólidos compitiendo romperían la
/// jerarquía. El texto oscuro también garantiza contraste en el tono mostaza.
class RecurringPaymentTypeTag extends StatelessWidget {
  const RecurringPaymentTypeTag({super.key, required this.type});

  final RecurringPaymentValueType type;

  @override
  Widget build(BuildContext context) {
    final isFixed = type == RecurringPaymentValueType.FIXED;

    return RecurringPaymentPill(
      label: type.friendlyName(context.l10n),
      color: isFixed ? AppColors.purple : AppColors.mustard,
      textColor: isFixed ? AppColors.purple : const Color(0xFF8A5A00),
    );
  }
}
