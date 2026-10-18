/// Formatting helpers for boleto input and display.
class RecurringPaymentBoleto {
  const RecurringPaymentBoleto._();

  static String onlyDigits(String value) => value.replaceAll(RegExp(r'\D'), '');

  /// Texto de ayuda para el campo: agrupa en bloques legibles sin alterar la
  /// secuencia que se envía.
  static String grouped(String value) {
    final digits = onlyDigits(value);
    final buffer = StringBuffer();

    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && index % 12 == 0) buffer.write(' ');
      buffer.write(digits[index]);
    }
    return buffer.toString();
  }

  /// Últimos dígitos, para identificar el boleto en la confirmación.
  static String lastDigits(String value, {int length = 4}) {
    final digits = onlyDigits(value);
    if (digits.length <= length) return digits;
    return digits.substring(digits.length - length);
  }
}
