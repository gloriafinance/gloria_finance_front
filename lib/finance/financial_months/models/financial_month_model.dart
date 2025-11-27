class FinancialMonthModel {
  final String id;
  final int month;
  final int year;
  final bool closed;
  final String churchId;
  final String financialMonthId;

  FinancialMonthModel({
    required this.id,
    required this.month,
    required this.year,
    required this.closed,
    required this.churchId,
    required this.financialMonthId,
  });

  factory FinancialMonthModel.fromJson(Map<String, dynamic> json) {
    return FinancialMonthModel(
      id: json['id'] ?? '',
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      closed: json['closed'] ?? false,
      churchId: json['churchId'] ?? '',
      financialMonthId: json['financialMonthId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'month': month,
        'year': year,
        'closed': closed,
        'churchId': churchId,
        'financialMonthId': financialMonthId,
      };

  String get monthName {
    const months = [
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
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }

  String get statusText => closed ? 'Fechado' : 'Aberto';
}
