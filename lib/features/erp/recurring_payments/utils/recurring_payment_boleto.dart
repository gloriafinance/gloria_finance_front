/// Reglas de la línea digitável del boleto.
///
/// El valor lo lee el banco desde la propia línea, así que acá solo se valida la
/// forma y se prepara el texto: la única fuente de verdad del importe es
/// `church-banking`.
class RecurringPaymentBoleto {
  const RecurringPaymentBoleto._();

  /// Un boleto bancário tiene 47 dígitos digitados (o 44 en el código de
  /// barras) y los carnês de arrecadação/convênio tienen 48. El banco rechaza
  /// los de 48 porque ese layout no define una posición de valor, así que la
  /// pantalla tampoco los acepta.
  static const Set<int> supportedLengths = {44, 47};

  static String onlyDigits(String value) => value.replaceAll(RegExp(r'\D'), '');

  static bool isValid(String value) {
    final digits = onlyDigits(value);
    return supportedLengths.contains(digits.length);
  }

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
