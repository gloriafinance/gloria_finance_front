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