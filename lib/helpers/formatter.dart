import 'currency_formatter.dart';
import 'date_formatter.dart';

// Función auxiliar para formatear moneda
String formatCurrency(double amount, {String? symbol}) {
  return CurrencyFormatter.formatCurrency(amount, symbol: symbol);
}

// Función auxiliar para formatear fechas
String formatDate(String date) {
  return convertDateFormatToDDMMYYYY(date);
}

Map<String, dynamic>? mapOrNull(dynamic value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value as Map);
  }
  return null;
}

String? stringOrNull(dynamic value) {
  if (value == null) return null;
  final stringValue = value.toString();
  if (stringValue.isEmpty || stringValue == 'null') {
    return null;
  }
  return stringValue;
}

String stringOrEmpty(dynamic value) {
  return stringOrNull(value) ?? '';
}

double parseAmount(dynamic value) {
  if (value == null) return 0.0;
  return double.tryParse(value.toString()) ?? 0.0;
}

bool? parseNullableBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.toLowerCase();
    if (normalized == 'true') return true;
    if (normalized == 'false') return false;
  }
  return null;
}
