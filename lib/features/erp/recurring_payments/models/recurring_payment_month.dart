/// Nombres de mes en portugués, en el orden del contrato.
const List<String> _monthsPtBr = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

/// Una competencia (mes) del calendario de São Paulo, que es el que usa el API.
///
/// Brasil no tiene horario de verano desde 2019, así que el mes de São Paulo es
/// siempre UTC-3. Calcularlo con ese desplazamiento (y no con la hora del
/// dispositivo) evita que un tesorero en otro huso vea el mes equivocado.
class RecurringPaymentMonth {
  const RecurringPaymentMonth({required this.year, required this.month});

  final int year;
  final int month;

  static const Duration _saoPauloOffset = Duration(hours: -3);
  static final RegExp _competencePattern = RegExp(r'^\d{4}-(0[1-9]|1[0-2])$');

  factory RecurringPaymentMonth.current([DateTime? now]) {
    final saoPaulo = (now ?? DateTime.now()).toUtc().add(_saoPauloOffset);
    return RecurringPaymentMonth(year: saoPaulo.year, month: saoPaulo.month);
  }

  /// Devuelve `null` cuando el texto no es una competencia del contrato.
  static RecurringPaymentMonth? tryParse(String? competence) {
    if (competence == null || !_competencePattern.hasMatch(competence)) {
      return null;
    }
    final parts = competence.split('-');
    return RecurringPaymentMonth(
      year: int.parse(parts[0]),
      month: int.parse(parts[1]),
    );
  }

  String get competence => '$year-${month.toString().padLeft(2, '0')}';

  RecurringPaymentMonth get previous => _shift(-1);

  RecurringPaymentMonth get next => _shift(1);

  /// "Outubro 2026" — lo que muestra el selector de competencia.
  String get label => '${_monthsPtBr[month - 1]} $year';

  /// "Outubro / 2026" — como aparece en las confirmaciones.
  String get slashLabel => '${_monthsPtBr[month - 1]} / $year';

  /// "10 OUT" — como aparece en las tarjetas de mobile.
  String dueDayLabel(DateTime dueDate) =>
      '${dueDate.day.toString().padLeft(2, '0')} ${_monthsPtBr[dueDate.month - 1].substring(0, 3).toUpperCase()}';

  /// Día de vencimiento dentro de esta competencia.
  ///
  /// Misma regla que el backend: si el mes no tiene ese día, vale el último.
  DateTime dueDate(int dayOfMonth) {
    final lastDay = DateTime.utc(year, month + 1, 0).day;
    final day = dayOfMonth > lastDay ? lastDay : dayOfMonth;
    return DateTime(year, month, day);
  }

  RecurringPaymentMonth _shift(int months) {
    final total = year * 12 + (month - 1) + months;
    return RecurringPaymentMonth(year: total ~/ 12, month: total % 12 + 1);
  }
}
