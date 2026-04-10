import 'package:flutter/material.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

import '../cash_flow_service.dart';
import '../models/cash_flow_export_format.dart';
import '../models/cash_flow_filter_model.dart';
import '../models/cash_flow_model.dart';
import '../state/cash_flow_state.dart';
import '../utils/cash_flow_utils.dart';

class CashFlowStore extends ChangeNotifier {
  final service = CashFlowService();
  CashFlowState state = CashFlowState.empty();
  bool _bootstrapped = false;

  bool get isBootstrapped => _bootstrapped;

  void setStartDate(DateTime date) {
    final safeDate = DateTime(date.year, date.month, date.day);
    final endDate =
        safeDate.isAfter(state.filter.endDate)
            ? safeDate
            : state.filter.endDate;

    _setFilter(
      state.filter.copyWith(
        startDate: safeDate,
        endDate: endDate,
        groupBy:
            state.groupByTouched
                ? state.filter.groupBy
                : suggestCashFlowGroupBy(safeDate, endDate),
      ),
    );
  }

  void setEndDate(DateTime date) {
    final safeDate = DateTime(date.year, date.month, date.day);
    final startDate =
        safeDate.isBefore(state.filter.startDate)
            ? safeDate
            : state.filter.startDate;

    _setFilter(
      state.filter.copyWith(
        startDate: startDate,
        endDate: safeDate,
        groupBy:
            state.groupByTouched
                ? state.filter.groupBy
                : suggestCashFlowGroupBy(startDate, safeDate),
      ),
    );
  }

  void setGroupBy(CashFlowGroupBy groupBy) {
    _setFilter(state.filter.copyWith(groupBy: groupBy), groupByTouched: true);
  }

  void setMethod(String? method) {
    _setFilter(
      method == null
          ? state.filter.copyWith(clearMethod: true)
          : state.filter.copyWith(method: method),
    );
  }

  void setCostCenterId(String? costCenterId) {
    _setFilter(
      costCenterId == null
          ? state.filter.copyWith(clearCostCenterId: true)
          : state.filter.copyWith(costCenterId: costCenterId),
    );
  }

  void setIncludeProjection(bool includeProjection) {
    _setFilter(state.filter.copyWith(includeProjection: includeProjection));
  }

  void setProjectionBuckets(int value) {
    if (value <= 0) return;
    _setFilter(state.filter.copyWith(projectionBuckets: value));
  }

  void setSymbol(String? symbol) {
    _setFilter(
      symbol == null
          ? state.filter.copyWith(clearSymbol: true, availabilityAccountIds: [])
          : state.filter.copyWith(symbol: symbol),
    );
  }

  void setAvailabilityAccountIds(List<String> ids) {
    _setFilter(state.filter.copyWith(availabilityAccountIds: ids));
  }

  void clearFilters({
    String? defaultSymbol,
    List<String> defaultAvailabilityAccountIds = const [],
  }) {
    state = state.copyWith(
      filter: CashFlowFilterModel.init().copyWith(
        symbol: defaultSymbol,
        availabilityAccountIds: defaultAvailabilityAccountIds,
      ),
      groupByTouched: false,
    );
    notifyListeners();
  }

  Future<void> bootstrap({
    required List<String> availableSymbols,
    required String defaultSymbol,
    required List<String> defaultAvailabilityAccountIds,
  }) async {
    if (_bootstrapped || availableSymbols.isEmpty) return;

    final selectedSymbol =
        availableSymbols.contains(state.filter.symbol)
            ? state.filter.symbol
            : defaultSymbol;

    state = state.copyWith(
      filter: state.filter.copyWith(
        symbol: selectedSymbol,
        availabilityAccountIds: defaultAvailabilityAccountIds,
      ),
    );
    notifyListeners();

    _bootstrapped = true;
    await fetchCashFlow();
  }

  Future<void> fetchCashFlow() async {
    if (state.filter.symbol == null ||
        state.filter.symbol!.isEmpty ||
        state.filter.availabilityAccountIds.isEmpty) {
      state = state.copyWith(
        makeRequest: false,
        data: CashFlowReportModel.empty(),
      );
      notifyListeners();
      return;
    }

    try {
      state = state.copyWith(makeRequest: true);
      notifyListeners();

      final data = await service.fetchCashFlow(state.filter);

      state = state.copyWith(makeRequest: false, data: data);
      notifyListeners();
    } catch (e) {
      debugPrint('Error al obtener el flujo de caja: $e');
      state = state.copyWith(
        makeRequest: false,
        data: CashFlowReportModel.empty(),
      );
      notifyListeners();
    }
  }

  Future<CashFlowBucketDetailsModel?> fetchBucketDetails(
    CashFlowSeriesRowModel row,
  ) async {
    final bucketRange = resolveCashFlowBucketRange(
      period: row.period,
      groupBy: state.filter.groupBy,
      minDate: state.filter.startDate,
      maxDate: state.filter.endDate,
    );

    state = state.copyWith(loadingDetails: true);
    notifyListeners();

    try {
      final details = await service.fetchCashFlowDetails(
        state.filter.copyWith(
          startDate: bucketRange.start,
          endDate: bucketRange.end,
        ),
      );

      state = state.copyWith(loadingDetails: false);
      notifyListeners();

      return details;
    } catch (e) {
      debugPrint('Error al obtener el detalle del bucket: $e');
      state = state.copyWith(loadingDetails: false);
      notifyListeners();
      return null;
    }
  }

  Future<void> exportCsv(BuildContext context) async {
    await _export(context, CashFlowExportFormat.csv);
  }

  Future<void> exportPdf(BuildContext context) async {
    await _export(context, CashFlowExportFormat.pdf);
  }

  Future<void> _export(
    BuildContext context,
    CashFlowExportFormat format,
  ) async {
    if (format == CashFlowExportFormat.csv && state.exportingCsv) return;
    if (format == CashFlowExportFormat.pdf && state.exportingPdf) return;

    state = state.copyWith(
      exportingCsv:
          format == CashFlowExportFormat.csv ? true : state.exportingCsv,
      exportingPdf:
          format == CashFlowExportFormat.pdf ? true : state.exportingPdf,
    );
    notifyListeners();

    final successMessage = context.l10n.reports_cash_flow_export_success;
    final errorMessage = context.l10n.reports_cash_flow_export_error;

    try {
      final success = await service.exportCashFlow(
        state.filter,
        format: format,
      );

      Toast.showMessage(
        success ? successMessage : errorMessage,
        success ? ToastType.success : ToastType.error,
      );
    } catch (e) {
      debugPrint('Error al exportar flujo de caja: $e');
      Toast.showMessage(errorMessage, ToastType.error);
    } finally {
      state = state.copyWith(exportingCsv: false, exportingPdf: false);
      notifyListeners();
    }
  }

  void _setFilter(CashFlowFilterModel filter, {bool? groupByTouched}) {
    state = state.copyWith(filter: filter, groupByTouched: groupByTouched);
    notifyListeners();
  }
}
