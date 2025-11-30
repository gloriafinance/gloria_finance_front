// lib/finance/reports/pages/dre/models/dre_filter_model.dart

class DREFilterModel {
  String churchId;
  int year;
  int? month; // Optional, si se omite retorna el año completo

  DREFilterModel({
    required this.churchId,
    required this.year,
    this.month,
  });

  factory DREFilterModel.init() {
    return DREFilterModel(
      churchId: '',
      year: DateTime.now().year,
      month: DateTime.now().month,
    );
  }

  DREFilterModel copyWith({
    String? churchId,
    int? year,
    int? month,
  }) {
    return DREFilterModel(
      churchId: churchId ?? this.churchId,
      year: year ?? this.year,
      month: month ?? this.month,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'churchId': churchId,
      'year': year,
    };
    
    // Solo incluir month si tiene valor
    if (month != null && month! > 0) {
      json['month'] = month!;
    }
    
    return json;
  }
}
