import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_launch_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/analyze_report_with_support_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/cash_flow_model.dart';
import 'models/cash_flow_filter_model.dart';
import 'store/cash_flow_store.dart';
import 'utils/cash_flow_utils.dart';
import 'widgets/cash_flow_cards.dart';
import 'widgets/cash_flow_chart.dart';
import 'widgets/cash_flow_details_dialog.dart';
import 'widgets/cash_flow_filters.dart';
import 'widgets/cash_flow_tables.dart';

class CashFlowScreen extends StatelessWidget {
  const CashFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);
    CurrencyFormatter.updateLocale(Localizations.localeOf(context));

    return ChangeNotifierProvider(
      create: (_) => CashFlowStore(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildTitle(context), _buildContent()],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      context.l10n.erp_menu_reports_cash_flow,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _buildContent() {
    return Consumer3<
      CashFlowStore,
      AvailabilityAccountsListStore,
      AuthSessionStore
    >(
      builder: (context, store, accountStore, authStore, _) {
        final methodVisibleAccounts = resolveCashFlowVisibleAccounts(
          accounts: accountStore.state.availabilityAccounts,
          accountType: store.state.filter.method,
        );
        final visibleSymbols = resolveCashFlowSymbols(
          accounts: methodVisibleAccounts,
        );
        final preferredSessionSymbol =
            authStore.state.session.symbolFormatMoney;
        final defaultSymbol =
            visibleSymbols.contains(preferredSessionSymbol)
                ? preferredSessionSymbol
                : visibleSymbols.isNotEmpty
                ? visibleSymbols.first
                : null;
        final selectedSymbol =
            visibleSymbols.contains(store.state.filter.symbol)
                ? store.state.filter.symbol
                : defaultSymbol;
        final symbolAccounts = resolveCashFlowAccountsBySymbol(
          accounts: methodVisibleAccounts,
          symbol: selectedSymbol,
        );
        final selectedAccountIds = resolveCashFlowAccountSelection(
          accounts: symbolAccounts,
          selectedIds: store.state.filter.availabilityAccountIds,
        );
        final currencySymbol = selectedSymbol;
        final isLoading = store.state.makeRequest;
        final data = store.state.data;
        final waitingForAccounts =
            !store.isBootstrapped && accountStore.state.makeRequest;

        if (!store.isBootstrapped &&
            selectedSymbol != null &&
            symbolAccounts.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            store.bootstrap(
              availableSymbols: visibleSymbols,
              defaultSymbol: defaultSymbol ?? selectedSymbol,
              defaultAvailabilityAccountIds: selectedAccountIds,
            );
          });
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CashFlowFilters(),
                if (data.hasSeries) ...[
                  const SizedBox(height: 16),
                  _buildAnalyzeButton(context, store),
                ],
                const SizedBox(height: 24),
                _ReportHeader(data: data, filter: store.state.filter),
                const SizedBox(height: 16),
                if (data.messages.isNotEmpty) ...[
                  ...data.messages.map(
                    (message) => _InfoBanner(message: message),
                  ),
                  const SizedBox(height: 16),
                ],
                if (waitingForAccounts || isLoading)
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 80),
                    child: const CircularProgressIndicator(),
                  )
                else if (!data.hasSeries)
                  _EmptyState(message: context.l10n.reports_cash_flow_empty)
                else ...[
                  CashFlowSummaryCards(
                    summary: data.summary,
                    currencySymbol: currencySymbol,
                  ),
                  const SizedBox(height: 28),
                  CashFlowChart(
                    series: data.series,
                    groupBy: store.state.filter.groupBy,
                    rangeEnd: store.state.filter.endDate,
                  ),
                  const SizedBox(height: 28),
                  CashFlowSeriesTable(
                    series: data.series,
                    groupBy: store.state.filter.groupBy,
                    reportEndDate: store.state.filter.endDate,
                    currencySymbol: currencySymbol,
                    onViewDetails: (row) async {
                      final details = await store.fetchBucketDetails(row);
                      if (details == null || !context.mounted) return;
                      await showCashFlowDetailsDialog(
                        context,
                        details,
                        currencySymbol,
                      );
                    },
                  ),
                  if (store.state.filter.includeProjection) ...[
                    const SizedBox(height: 28),
                    CashFlowProjectionTable(
                      projection: data.projection,
                      groupBy: store.state.filter.groupBy,
                      currencySymbol: currencySymbol,
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyzeButton(BuildContext context, CashFlowStore store) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AnalyzeReportWithSupportButton(
        label: context.l10n.support_assistant_action_analyze_report,
        onPressed: () {
          context.push(
            '/support-assistant',
            extra: SupportAssistantLaunchModel(
              question: context.l10n.support_assistant_analysis_question,
              analysisTarget: SupportAssistantAnalysisTargetModel(
                type: SupportAssistantAnalysisTargetType.report,
                title: context.l10n.erp_menu_reports_cash_flow,
                data: {
                  'reportType': 'cash_flow',
                  'route': '/report/cash-flow',
                  'filter': store.state.filter.toJson(),
                  'reportData': _buildReportAnalysisPayload(store.state.data),
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _buildReportAnalysisPayload(CashFlowReportModel data) {
    return {
      'reportName': data.reportName,
      'generatedAt': data.generatedAt?.toIso8601String(),
      'summary': {
        'openingBalance': data.summary.openingBalance,
        'entries': data.summary.entries,
        'exits': data.summary.exits,
        'net': data.summary.net,
        'closingBalance': data.summary.closingBalance,
      },
      'series': data.series
          .map(
            (row) => {
              'period': row.period.toIso8601String(),
              'entries': row.entries,
              'exits': row.exits,
              'net': row.net,
              'runningBalance': row.runningBalance,
            },
          )
          .toList(growable: false),
      'projection': {
        'label': data.projection.label,
        'status': data.projection.status.name,
        'message': data.projection.message,
        'buckets': data.projection.buckets
            .map(
              (row) => {
                'period': row.period.toIso8601String(),
                'projectedEntries': row.projectedEntries,
                'projectedExits': row.projectedExits,
                'projectedNet': row.projectedNet,
                'projectedBalance': row.projectedBalance,
              },
            )
            .toList(growable: false),
      },
      'messages': data.messages,
    };
  }
}

class _ReportHeader extends StatelessWidget {
  final CashFlowReportModel data;
  final CashFlowFilterModel filter;

  const _ReportHeader({required this.data, required this.filter});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final accountStore = context.watch<AvailabilityAccountsListStore>();
    final costCenterStore = context.watch<CostCenterListStore>();
    final reportName =
        data.reportName.isEmpty
            ? context.l10n.erp_menu_reports_cash_flow
            : data.reportName;
    final generatedAt =
        data.generatedAt == null
            ? '-'
            : cashFlowDateTime(data.generatedAt!, locale: locale);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reportName,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.reports_cash_flow_header_subtitle,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetaChip(
                label: context.l10n.reports_cash_flow_meta_range(
                  '${cashFlowDisplayDate(filter.startDate, locale: locale)} - ${cashFlowDisplayDate(filter.endDate, locale: locale)}',
                ),
              ),
              _MetaChip(
                label: context.l10n.reports_cash_flow_meta_group_by(
                  filter.groupBy.friendlyName(context.l10n),
                ),
              ),
              _MetaChip(
                label: context.l10n.reports_cash_flow_meta_generated_at(
                  generatedAt,
                ),
              ),
              if (filter.includeProjection)
                _MetaChip(
                  label: context.l10n.reports_cash_flow_meta_projection(
                    filter.projectionBuckets.toString(),
                  ),
                ),
              ..._activeFilterChips(context, accountStore, costCenterStore),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _activeFilterChips(
    BuildContext context,
    AvailabilityAccountsListStore accountStore,
    CostCenterListStore costCenterStore,
  ) {
    final chips = <Widget>[];

    if (filter.method != null) {
      chips.add(
        _MetaChip(
          label:
              '${context.l10n.reports_cash_flow_filter_account_types}: ${AccountTypeExtension.fromApiValue(filter.method!).friendlyName(context.l10n)}',
        ),
      );
    }

    if (filter.costCenterId != null) {
      final costCenter = costCenterStore.findByCostCenterId(
        filter.costCenterId!,
      );
      if (costCenter != null) {
        chips.add(
          _MetaChip(
            label:
                '${context.l10n.reports_cash_flow_filter_cost_center}: ${costCenter.name}',
          ),
        );
      }
    }

    if (filter.symbol != null) {
      chips.add(
        _MetaChip(
          label:
              '${context.l10n.reports_dre_primary_currency_badge}: ${filter.symbol}',
        ),
      );
    }

    if (filter.availabilityAccountIds.isNotEmpty) {
      final symbolAccounts = resolveCashFlowAccountsBySymbol(
        accounts: accountStore.state.availabilityAccounts,
        symbol: filter.symbol,
      );
      final label = cashFlowAccountsSummary(
        accounts: symbolAccounts,
        selectedIds: filter.availabilityAccountIds,
        allAccountsLabel: context.l10n.reports_cash_flow_filter_all_accounts,
        selectedAccountsLabel:
            context.l10n.reports_cash_flow_filter_selected_accounts,
      );

      chips.add(
        _MetaChip(
          label:
              '${context.l10n.reports_cash_flow_filter_availability_accounts}: $label',
        ),
      );
    }

    return chips;
  }
}

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 12,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String message;

  const _InfoBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF93C5FD)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDEE2E6)),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: Colors.black54,
        ),
      ),
    );
  }
}
