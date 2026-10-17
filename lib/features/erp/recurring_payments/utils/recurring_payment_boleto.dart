/// Reglas de la línea digitável del boleto.
///
/// El valor lo lee el banco desde la propia línea, así que acá solo se valida la
/// forma y se prepara el texto: la única fuente de verdad del importe es
/// `church-banking`.
class RecurringPaymentBoleto {
  const RecurringPaymentBoleto._();

  /// Tres formas válidas: boleto bancário digitado (47) y su código de barras
  /// (44), más la línea digitada de arrecadação/convênio (48), que es la de las
  /// contas de consumo (água, energia, gás, telecom).
  ///
  /// Acá solo se valida la forma. El importe lo lee el banco desde la propia
  /// línea, y decide si el documento trae un valor efectivo o solo uno de
  /// referencia; un documento de referencia se rechaza en el servidor con un
  /// mensaje propio, no acá.
  static const Set<int> supportedLengths = {44, 47, 48};

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
