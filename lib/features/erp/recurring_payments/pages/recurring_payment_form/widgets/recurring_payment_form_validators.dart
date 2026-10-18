import 'package:flutter/widgets.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

/// Validadores de UI del formulario de recurrencia.
///
/// Viven en un solo lugar porque la sección básica, la de configuración y la de PIX
/// comparten los mismos mensajes; las reglas de negocio siguen en el dominio
/// de la API, que es quien decide de verdad.
String? nameValidator(BuildContext context, String? value) {
  if (value == null || value.trim().isEmpty) {
    return context.l10n.recurringPayments_error_name_required;
  }
  return null;
}

String? selectionValidator(
  BuildContext context,
  String? value,
  String message,
) {
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  return null;
}

/// El valor solo es obligatorio cuando el tipo elegido es "Valor fixo"; en
/// "Valor variável" no existe valor permanente que validar.
String? amountValidator(
  BuildContext context,
  String? value, {
  required bool isRequired,
}) {
  if (!isRequired) return null;

  if (value == null || value.trim().isEmpty) {
    return context.l10n.recurringPayments_error_amount_required;
  }

  return null;
}

String? dueDayValidator(BuildContext context, String? value) {
  return selectionValidator(
    context,
    value,
    context.l10n.recurringPayments_error_due_day_required,
  );
}

/// La clave PIX solo es obligatoria cuando el destino reutilizable está activado.
String? pixKeyValidator(
  BuildContext context,
  String? value, {
  required bool isRequired,
}) {
  if (!isRequired) return null;

  return selectionValidator(
    context,
    value,
    context.l10n.recurringPayments_error_pix_key_required,
  );
}
