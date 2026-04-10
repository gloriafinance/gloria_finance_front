import '../models/cash_flow_filter_model.dart';
import '../models/cash_flow_model.dart';

class CashFlowState {
  final bool makeRequest;
  final bool exportingCsv;
  final bool exportingPdf;
  final bool loadingDetails;
  final bool groupByTouched;
  final CashFlowFilterModel filter;
  final CashFlowReportModel data;

  const CashFlowState({
    required this.makeRequest,
    required this.exportingCsv,
    required this.exportingPdf,
    required this.loadingDetails,
    required this.groupByTouched,
    required this.filter,
    required this.data,
  });

  factory CashFlowState.empty() {
    return CashFlowState(
      makeRequest: false,
      exportingCsv: false,
      exportingPdf: false,
      loadingDetails: false,
      groupByTouched: false,
      filter: CashFlowFilterModel.init(),
      data: CashFlowReportModel.empty(),
    );
  }

  CashFlowState copyWith({
    bool? makeRequest,
    bool? exportingCsv,
    bool? exportingPdf,
    bool? loadingDetails,
    bool? groupByTouched,
    CashFlowFilterModel? filter,
    CashFlowReportModel? data,
  }) {
    return CashFlowState(
      makeRequest: makeRequest ?? this.makeRequest,
      exportingCsv: exportingCsv ?? this.exportingCsv,
      exportingPdf: exportingPdf ?? this.exportingPdf,
      loadingDetails: loadingDetails ?? this.loadingDetails,
      groupByTouched: groupByTouched ?? this.groupByTouched,
      filter: filter ?? this.filter,
      data: data ?? this.data,
    );
  }
}
