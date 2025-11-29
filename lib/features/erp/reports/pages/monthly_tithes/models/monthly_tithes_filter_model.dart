class MonthlyTithesFilterModel {
  String churchId;
  int month;
  int year;

  MonthlyTithesFilterModel({
    required this.churchId,
    required this.month,
    required this.year,
  });

  factory MonthlyTithesFilterModel.init() {
    return MonthlyTithesFilterModel(
      churchId: '',
      month: DateTime.now().month,
      year: DateTime.now().year,
    );
  }

  MonthlyTithesFilterModel copyWith({
    String? churchId,
    int? month,
    int? year,
  }) {
    return MonthlyTithesFilterModel(
      churchId: churchId ?? this.churchId,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  toJson() {
    return {
      'churchId': churchId,
      'month': month,
      'year': year,
    };
  }
}
