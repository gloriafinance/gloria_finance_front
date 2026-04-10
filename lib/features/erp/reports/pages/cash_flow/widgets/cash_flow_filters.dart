import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/index.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:gloria_finance/features/erp/widgets/statement_category_help.dart';
import 'package:provider/provider.dart';

import '../models/cash_flow_filter_model.dart';
import '../store/cash_flow_store.dart';
import '../utils/cash_flow_utils.dart';

class CashFlowFilters extends StatefulWidget {
  const CashFlowFilters({super.key});

  @override
  State<CashFlowFilters> createState() => _CashFlowFiltersState();
}

class _CashFlowFiltersState extends State<CashFlowFilters> {
  bool isExpandedFilter = false;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CashFlowStore>();
    final accountStore = context.watch<AvailabilityAccountsListStore>();
    final costCenterStore = context.watch<CostCenterListStore>();
    final methodVisibleAccounts = _visibleAccounts(
      accountStore,
      store.state.filter.method,
    );
    final symbolAccounts = resolveCashFlowAccountsBySymbol(
      accounts: methodVisibleAccounts,
      symbol: store.state.filter.symbol,
    );

    _syncSelection(store, methodVisibleAccounts);

    return isMobile(context)
        ? _layoutMobile(store, accountStore, costCenterStore, symbolAccounts)
        : _layoutDesktop(store, accountStore, costCenterStore, symbolAccounts);
  }

  Widget _layoutDesktop(
    CashFlowStore store,
    AvailabilityAccountsListStore accountStore,
    CostCenterListStore costCenterStore,
    List<AvailabilityAccountModel> symbolAccounts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _startDateField(store)),
            const SizedBox(width: 12),
            Expanded(child: _endDateField(store)),
            const SizedBox(width: 12),
            Expanded(child: _groupByField(store)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _methodField(store, accountStore)),
            const SizedBox(width: 12),
            Expanded(child: _costCenterField(store, costCenterStore)),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()),
          ],
        ),
        Row(
          children: [
            Expanded(child: _availabilityAccountsField(store, symbolAccounts)),
            const SizedBox(width: 12),
            Expanded(child: _projectionToggle(store)),
            const SizedBox(width: 12),
            Expanded(child: _projectionBucketsField(store)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _clearButton(store, accountStore),
            const SizedBox(width: 12),
            _applyButton(store),
            const SizedBox(width: 12),
            _exportCsvButton(store),
            const SizedBox(width: 12),
            _exportPdfButton(store),
          ],
        ),
      ],
    );
  }

  Widget _layoutMobile(
    CashFlowStore store,
    AvailabilityAccountsListStore accountStore,
    CostCenterListStore costCenterStore,
    List<AvailabilityAccountModel> symbolAccounts,
  ) {
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        isExpandedFilter = isExpanded;
        setState(() {});
      },
      animationDuration: const Duration(milliseconds: 500),
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          isExpanded: isExpandedFilter,
          headerBuilder: (context, isOpen) {
            return ListTile(
              title: Text(
                context.l10n.common_filters_upper,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.fontTitle,
                  color: AppColors.purple,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _startDateField(store),
                _endDateField(store),
                _groupByField(store),
                _methodField(store, accountStore),
                _costCenterField(store, costCenterStore),
                _availabilityAccountsField(store, symbolAccounts),
                _projectionToggle(store),
                _projectionBucketsField(store),
                const SizedBox(height: 16),
                _applyButton(store),
                const SizedBox(height: 10),
                _clearButton(store, accountStore),
                const SizedBox(height: 10),
                _exportCsvButton(store),
                const SizedBox(height: 10),
                _exportPdfButton(store),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _startDateField(CashFlowStore store) {
    return Input(
      label: context.l10n.common_start_date,
      readOnly: true,
      initialValue: cashFlowDisplayDate(store.state.filter.startDate),
      onChanged: (_) {},
      onTap: () async {
        final picked = await selectDate(
          context,
          initialDate: store.state.filter.startDate,
        );
        if (picked == null) return;
        store.setStartDate(picked);
      },
    );
  }

  Widget _endDateField(CashFlowStore store) {
    return Input(
      label: context.l10n.common_end_date,
      readOnly: true,
      initialValue: cashFlowDisplayDate(store.state.filter.endDate),
      onChanged: (_) {},
      onTap: () async {
        final picked = await selectDate(
          context,
          initialDate: store.state.filter.endDate,
        );
        if (picked == null) return;
        store.setEndDate(picked);
      },
    );
  }

  Widget _groupByField(CashFlowStore store) {
    final options = CashFlowGroupBy.values
        .map((item) => item.friendlyName(context.l10n))
        .toList(growable: false);

    return Dropdown(
      label: context.l10n.reports_cash_flow_filter_group_by,
      items: options,
      initialValue: store.state.filter.groupBy.friendlyName(context.l10n),
      onChanged: (value) {
        final selected = CashFlowGroupBy.values.firstWhere(
          (item) => item.friendlyName(context.l10n) == value,
        );
        store.setGroupBy(selected);
      },
    );
  }

  Widget _methodField(
    CashFlowStore store,
    AvailabilityAccountsListStore accountStore,
  ) {
    final options = AccountType.values
        .map((item) => item.friendlyName(context.l10n))
        .toList(growable: false);

    final initialValue =
        store.state.filter.method == null
            ? null
            : AccountTypeExtension.fromApiValue(
              store.state.filter.method!,
            ).friendlyName(context.l10n);

    return Dropdown(
      label: context.l10n.reports_cash_flow_filter_account_types,
      items: options,
      initialValue: initialValue,
      onChanged: (value) {
        final selected = AccountType.values.firstWhere(
          (item) => item.friendlyName(context.l10n) == value,
        );
        final methodVisibleAccounts = _visibleAccounts(
          accountStore,
          selected.apiValue,
        );
        final visibleSymbols = resolveCashFlowSymbols(
          accounts: methodVisibleAccounts,
        );
        final nextSymbol = _resolvePreferredSymbol(
          symbols: visibleSymbols,
          currentSymbol: store.state.filter.symbol,
        );
        final symbolAccounts = resolveCashFlowAccountsBySymbol(
          accounts: methodVisibleAccounts,
          symbol: nextSymbol,
        );
        final nextSelection = resolveCashFlowAccountSelection(
          accounts: symbolAccounts,
          selectedIds: store.state.filter.availabilityAccountIds,
        );

        store.setMethod(selected.apiValue);
        store.setSymbol(nextSymbol);
        store.setAvailabilityAccountIds(nextSelection);
      },
    );
  }

  Widget _costCenterField(
    CashFlowStore store,
    CostCenterListStore costCenterStore,
  ) {
    final costCenters = costCenterStore.state.costCenters;
    final selectedCostCenter =
        store.state.filter.costCenterId == null
            ? null
            : costCenterStore.findByCostCenterId(
              store.state.filter.costCenterId!,
            );

    return Dropdown(
      label: context.l10n.reports_cash_flow_filter_cost_center,
      items: costCenters.map((item) => item.name).toList(growable: false),
      initialValue: selectedCostCenter?.name,
      onChanged: (value) {
        final selected = costCenters.firstWhere((item) => item.name == value);
        store.setCostCenterId(selected.costCenterId);
      },
    );
  }

  Widget _availabilityAccountsField(
    CashFlowStore store,
    List<AvailabilityAccountModel> accounts,
  ) {
    return Input(
      label: context.l10n.reports_cash_flow_filter_availability_accounts,
      readOnly: true,
      initialValue: cashFlowAccountsSummary(
        accounts: accounts,
        selectedIds: store.state.filter.availabilityAccountIds,
        allAccountsLabel: context.l10n.reports_cash_flow_filter_all_accounts,
        selectedAccountsLabel:
            context.l10n.reports_cash_flow_filter_selected_accounts,
      ),
      iconRight: const Icon(Icons.arrow_drop_down),
      onChanged: (_) {},
      onTap:
          () => _showAccountSelector(
            store,
            _visibleAccounts(
              context.read<AvailabilityAccountsListStore>(),
              store.state.filter.method,
            ),
          ),
    );
  }

  Widget _projectionToggle(CashFlowStore store) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: CheckboxListTile(
        value: store.state.filter.includeProjection,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          context.l10n.reports_cash_flow_filter_include_projection,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        onChanged: (value) => store.setIncludeProjection(value ?? false),
      ),
    );
  }

  Widget _projectionBucketsField(CashFlowStore store) {
    return Input(
      label: context.l10n.reports_cash_flow_filter_projection_horizon,
      labelSuffix: _projectionBucketsHelp(),
      readOnly: !store.state.filter.includeProjection,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      initialValue:
          store.state.filter.includeProjection
              ? store.state.filter.projectionBuckets.toString()
              : context.l10n.reports_cash_flow_projection_disabled,
      onChanged: (value) {
        final parsed = int.tryParse(value);
        if (parsed == null) return;
        store.setProjectionBuckets(parsed);
      },
    );
  }

  Widget _projectionBucketsHelp() {
    return StatementCategoryHelpButton(
      dialogTitle: context.l10n.reports_cash_flow_projection_help_title,
      closeText: context.l10n.common_understood,
      tooltipMessage: context.l10n.reports_cash_flow_projection_help_tooltip,
      entries: [
        StatementCategoryHelpEntry(
          title: context.l10n.reports_cash_flow_filter_projection_horizon,
          body: context.l10n.reports_cash_flow_projection_help_body,
        ),
      ],
    );
  }

  Widget _applyButton(CashFlowStore store) {
    return ButtonActionTable(
      color: AppColors.blue,
      text:
          store.state.makeRequest
              ? context.l10n.common_loading
              : context.l10n.common_apply_filters,
      icon: store.state.makeRequest ? Icons.hourglass_bottom : Icons.search,
      onPressed: () {
        if (isExpandedFilter) {
          setState(() {
            isExpandedFilter = false;
          });
        }
        store.fetchCashFlow();
      },
    );
  }

  Widget _clearButton(
    CashFlowStore store,
    AvailabilityAccountsListStore accountStore,
  ) {
    final authStore = context.read<AuthSessionStore>();
    final accounts = _visibleAccounts(accountStore, null);
    final symbols = resolveCashFlowSymbols(accounts: accounts);
    final preferredSessionSymbol = authStore.state.session.symbolFormatMoney;
    final defaultSymbol =
        symbols.contains(preferredSessionSymbol)
            ? preferredSessionSymbol
            : symbols.isNotEmpty
            ? symbols.first
            : null;
    final defaultSelection = resolveCashFlowAccountsBySymbol(
      accounts: accounts,
      symbol: defaultSymbol,
    );

    return ButtonActionTable(
      color: Colors.grey,
      text: context.l10n.common_clear,
      icon: Icons.refresh,
      onPressed: () {
        store.clearFilters(
          defaultSymbol: defaultSymbol,
          defaultAvailabilityAccountIds: defaultSelection
              .map((item) => item.availabilityAccountId)
              .toList(growable: false),
        );
      },
    );
  }

  Widget _exportCsvButton(CashFlowStore store) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomButton(
          text: context.l10n.reports_cash_flow_export_csv,
          backgroundColor: AppColors.blue,
          textColor: Colors.white,
          icon: Icons.table_view,
          padding: const EdgeInsets.only(bottom: 6, top: 6),
          onPressed:
              store.state.exportingCsv ? null : () => store.exportCsv(context),
        ),
        if (store.state.exportingCsv)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  Widget _exportPdfButton(CashFlowStore store) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomButton(
          text: context.l10n.reports_cash_flow_export_pdf,
          backgroundColor: AppColors.blue,
          textColor: Colors.white,
          icon: Icons.picture_as_pdf,
          padding: const EdgeInsets.only(bottom: 6, top: 6),
          onPressed:
              store.state.exportingPdf ? null : () => store.exportPdf(context),
        ),
        if (store.state.exportingPdf)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  List<AvailabilityAccountModel> _visibleAccounts(
    AvailabilityAccountsListStore accountStore,
    String? accountType,
  ) {
    return resolveCashFlowVisibleAccounts(
      accounts: accountStore.state.availabilityAccounts,
      accountType: accountType,
    );
  }

  Future<void> _showAccountSelector(
    CashFlowStore store,
    List<AvailabilityAccountModel> accounts,
  ) async {
    final symbols = resolveCashFlowSymbols(accounts: accounts);
    if (symbols.isEmpty) {
      return;
    }

    var selectedSymbol =
        _resolvePreferredSymbol(
          symbols: symbols,
          currentSymbol: store.state.filter.symbol,
        )!;
    var visibleAccounts = resolveCashFlowAccountsBySymbol(
      accounts: accounts,
      symbol: selectedSymbol,
    );
    final selected = Set<String>.from(
      resolveCashFlowAccountSelection(
        accounts: visibleAccounts,
        selectedIds: store.state.filter.availabilityAccountIds,
      ),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                context.l10n.reports_cash_flow_filter_availability_accounts,
                style: const TextStyle(fontFamily: AppFonts.fontTitle),
              ),
              content: SizedBox(
                width: 560,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Dropdown(
                        label: context.l10n.reports_dre_primary_currency_badge,
                        items: symbols,
                        initialValue: selectedSymbol,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedSymbol = value;
                            visibleAccounts = resolveCashFlowAccountsBySymbol(
                              accounts: accounts,
                              symbol: selectedSymbol,
                            );
                            selected
                              ..clear()
                              ..addAll(
                                visibleAccounts.map(
                                  (item) => item.availabilityAccountId,
                                ),
                              );
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            setDialogState(() {
                              selected
                                ..clear()
                                ..addAll(
                                  visibleAccounts.map(
                                    (item) => item.availabilityAccountId,
                                  ),
                                );
                            });
                          },
                          child: Text(
                            context.l10n.reports_cash_flow_filter_all_accounts,
                          ),
                        ),
                      ),
                      ...visibleAccounts.map(
                        (account) => CheckboxListTile(
                          value: selected.contains(
                            account.availabilityAccountId,
                          ),
                          title: Text(account.accountName),
                          subtitle: Text(
                            AccountTypeExtension.fromApiValue(
                              account.accountType,
                            ).friendlyName(context.l10n),
                          ),
                          onChanged: (value) {
                            setDialogState(() {
                              if (value == true) {
                                selected.add(account.availabilityAccountId);
                              } else {
                                selected.remove(account.availabilityAccountId);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(context.l10n.common_cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nextSelection =
                        selected.isEmpty
                            ? visibleAccounts
                                .map((item) => item.availabilityAccountId)
                                .toList(growable: false)
                            : selected.toList(growable: false);

                    store.setSymbol(selectedSymbol);
                    store.setAvailabilityAccountIds(nextSelection);
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(context.l10n.common_apply),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _syncSelection(
    CashFlowStore store,
    List<AvailabilityAccountModel> visibleAccounts,
  ) {
    if (visibleAccounts.isEmpty) {
      return;
    }

    final visibleSymbols = resolveCashFlowSymbols(accounts: visibleAccounts);
    final nextSymbol = _resolvePreferredSymbol(
      symbols: visibleSymbols,
      currentSymbol: store.state.filter.symbol,
    );
    final symbolAccounts = resolveCashFlowAccountsBySymbol(
      accounts: visibleAccounts,
      symbol: nextSymbol,
    );
    final nextSelection = resolveCashFlowAccountSelection(
      accounts: symbolAccounts,
      selectedIds: store.state.filter.availabilityAccountIds,
    );
    final sameSymbol = nextSymbol == store.state.filter.symbol;
    final sameSelection =
        nextSelection.length ==
            store.state.filter.availabilityAccountIds.length &&
        nextSelection.every(
          (item) => store.state.filter.availabilityAccountIds.contains(item),
        );

    if (sameSymbol && sameSelection) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      store.setSymbol(nextSymbol);
      store.setAvailabilityAccountIds(nextSelection);
    });
  }

  String? _resolvePreferredSymbol({
    required List<String> symbols,
    required String? currentSymbol,
  }) {
    if (symbols.isEmpty) {
      return null;
    }

    if (currentSymbol != null && symbols.contains(currentSymbol)) {
      return currentSymbol;
    }

    final sessionSymbol =
        context.read<AuthSessionStore>().state.session.symbolFormatMoney;
    if (symbols.contains(sessionSymbol)) {
      return sessionSymbol;
    }

    return symbols.first;
  }
}
