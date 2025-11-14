// lib/finance/reports/pages/dre/state/dre_state.dart

import '../models/dre_filter_model.dart';
import '../models/dre_model.dart';

class DREState {
  final bool makeRequest;
  final bool downloadingPdf;
  final DREFilterModel filter;
  final DREModel data;

  DREState({
    required this.makeRequest,
    required this.downloadingPdf,
    required this.filter,
    required this.data,
  });

  factory DREState.empty() {
    return DREState(
      makeRequest: false,
      downloadingPdf: false,
      filter: DREFilterModel.init(),
      data: DREModel.empty(),
    );
  }

  DREState copyWith({
    bool? makeRequest,
    bool? downloadingPdf,
    DREModel? data,
    String? churchId,
    int? month,
    int? year,
  }) {
    return DREState(
      makeRequest: makeRequest ?? this.makeRequest,
      downloadingPdf: downloadingPdf ?? this.downloadingPdf,
      data: data ?? this.data,
      filter: filter.copyWith(
        churchId: churchId,
        month: month,
        year: year,
      ),
    );
  }
}
