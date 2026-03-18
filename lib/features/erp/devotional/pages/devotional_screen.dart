import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/features/erp/devotional/models/devotional_models.dart';
import 'package:gloria_finance/features/erp/devotional/services/devotional_service.dart';
import 'package:gloria_finance/features/erp/devotional/utils/devotional_screen_utils.dart';
import 'package:gloria_finance/features/erp/devotional/widgets/devotional_agenda_tab.dart';
import 'package:gloria_finance/features/erp/devotional/widgets/devotional_community_insights_sheet.dart';
import 'package:gloria_finance/features/erp/devotional/widgets/devotional_config_section.dart';
import 'package:gloria_finance/features/erp/devotional/widgets/devotional_history_tab.dart';
import 'package:gloria_finance/features/erp/devotional/widgets/devotional_overview_panel.dart';
import 'package:gloria_finance/features/erp/devotional/widgets/devotional_setup_prompt.dart';

class DevotionalScreen extends StatefulWidget {
  const DevotionalScreen({super.key});

  @override
  State<DevotionalScreen> createState() => _DevotionalScreenState();
}

class _DevotionalScreenState extends State<DevotionalScreen>
    with SingleTickerProviderStateMixin {
  static const int _tabAgenda = 0;
  static const int _tabHistory = 1;
  static const int _tabConfigure = 2;

  final DevotionalService _service = DevotionalService();

  late TabController _tabController;

  bool _loading = true;
  bool _savingPlan = false;
  bool _loadingAgenda = false;
  bool _loadingHistory = false;

  bool _agendaLoaded = false;
  bool _historyLoaded = false;
  bool _hasExistingPlan = false;

  int _selectedTab = _tabAgenda;

  late String _weekStartDate;

  DevotionalPlanModel? _plan;
  DevotionalAgendaResponseModel? _agenda;
  DevotionalHistoryResponseModel? _history;

  String _agendaStatusFilter = '';
  String _agendaAudienceFilter = '';
  String _agendaChannelFilter = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _selectedTab,
    );
    _tabController.addListener(_onTabChanged);

    _weekStartDate = devotionalCurrentWeekMonday();
    _loadInitial();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    if (mounted) {
      setState(() => _loading = true);
    }

    try {
      await _loadPlan();
      await _loadInitialTabData();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadInitialTabData() async {
    if (_selectedTab == _tabAgenda && !_agendaLoaded && _hasExistingPlan) {
      _agendaLoaded = true;
      await _loadAgenda();
      return;
    }

    if (_selectedTab == _tabHistory && !_historyLoaded) {
      _historyLoaded = true;
      await _loadHistory();
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      return;
    }

    final index = _tabController.index;
    if (_selectedTab != index && mounted) {
      setState(() => _selectedTab = index);
    }

    if (index == _tabAgenda && !_agendaLoaded && _hasExistingPlan) {
      _agendaLoaded = true;
      _loadAgenda();
    }

    if (index == _tabHistory && !_historyLoaded) {
      _historyLoaded = true;
      _loadHistory();
    }
  }

  Future<void> _loadPlan() async {
    final response = await _service.getPlan(_weekStartDate);
    if (!mounted) return;

    var hasExistingPlan = response != null;
    var base = response ?? DevotionalPlanModel.empty(_weekStartDate);

    final timezoneWeekStart = devotionalCurrentWeekMonday(
      timezone: base.timezone,
    );
    if (timezoneWeekStart != _weekStartDate) {
      _weekStartDate = timezoneWeekStart;
      final timezoneResponse = await _service.getPlan(_weekStartDate);
      if (!mounted) return;

      hasExistingPlan = timezoneResponse != null;
      base =
          timezoneResponse ??
          DevotionalPlanModel.empty(
            _weekStartDate,
          ).copyWith(timezone: base.timezone);
    }

    setState(() {
      _hasExistingPlan = hasExistingPlan;
      _plan = _normalizePlan(base);
    });
  }

  Future<void> _loadAgenda() async {
    if (!_hasExistingPlan) {
      if (mounted) {
        setState(() => _agenda = null);
      }
      return;
    }

    if (mounted) {
      setState(() => _loadingAgenda = true);
    }

    try {
      final response = await _service.getAgenda(
        weekStartDate: _weekStartDate,
        status: _agendaStatusFilter.isEmpty ? null : _agendaStatusFilter,
        audience: _agendaAudienceFilter.isEmpty ? null : _agendaAudienceFilter,
        channel: _agendaChannelFilter.isEmpty ? null : _agendaChannelFilter,
      );

      if (!mounted) return;
      setState(() => _agenda = response);
    } finally {
      if (mounted) {
        setState(() => _loadingAgenda = false);
      }
    }
  }

  Future<void> _loadHistory() async {
    if (mounted) {
      setState(() => _loadingHistory = true);
    }

    try {
      final history = await _service.getHistory();
      if (!mounted) return;
      setState(() => _history = history);
    } finally {
      if (mounted) {
        setState(() => _loadingHistory = false);
      }
    }
  }

  Future<void> _openCommunityInsights(DevotionalAgendaItemModel item) async {
    final title =
        item.title?.isNotEmpty == true
            ? item.title!
            : context.l10n.devotional_item_no_title;

    if (isMobile(context)) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) {
          return DevotionalCommunityInsightsSheet(
            devotionalTitle: title,
            loadInsights:
                () => _service.getCommunityInsights(item.devotionalId),
          );
        },
      );
      return;
    }

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withAlpha(90),
      builder: (_) {
        return DevotionalCommunityInsightsSheet(
          devotionalTitle: title,
          loadInsights: () => _service.getCommunityInsights(item.devotionalId),
          presentation: DevotionalCommunityInsightsPresentation.dialog,
        );
      },
    );
  }

  Future<void> _savePlan() async {
    final plan = _plan;
    if (plan == null) return;

    final validationMessage = validateDevotionalPlan(context, plan);
    if (validationMessage != null) {
      Toast.showMessage(validationMessage, ToastType.warning);
      return;
    }

    if (mounted) {
      setState(() => _savingPlan = true);
    }

    try {
      final saved = await _service.upsertPlan(plan);
      if (!mounted) return;

      setState(() {
        _hasExistingPlan = true;
        _plan = _normalizePlan(saved);
      });

      Toast.showMessage(
        context.l10n.devotional_config_saved,
        ToastType.success,
      );

      if (_selectedTab == _tabAgenda || _agendaLoaded) {
        _agendaLoaded = true;
        await _loadAgenda();
      }
    } finally {
      if (mounted) {
        setState(() => _savingPlan = false);
      }
    }
  }

  Future<void> _openReview(DevotionalAgendaItemModel item) async {
    final updated = await context.push<bool>(
      '/devotional/review/${item.devotionalId}',
    );

    if (updated != true) {
      return;
    }

    if (_agendaLoaded && _hasExistingPlan) {
      await _loadAgenda();
    }
    if (_historyLoaded) {
      await _loadHistory();
    }
  }

  Future<void> _regenerateFromAgenda(String devotionalId) async {
    final l10n = context.l10n;

    try {
      await _runLoader(
        message: l10n.devotional_loader_generating,
        subtitle: l10n.devotional_loader_subtitle,
        action: () => _service.regenerate(devotionalId),
      );

      if (_agendaLoaded && _hasExistingPlan) {
        await _loadAgenda();
      }
      if (_historyLoaded) {
        await _loadHistory();
      }
    } catch (_) {
      if (mounted) {
        Toast.showMessage(l10n.devotional_operation_failed, ToastType.error);
      }
    }
  }

  Future<void> _retrySend(String devotionalId) async {
    final l10n = context.l10n;

    try {
      await _service.retrySend(devotionalId);
      if (!mounted) return;

      Toast.showMessage(l10n.devotional_retry_done, ToastType.success);

      if (_agendaLoaded && _hasExistingPlan) {
        await _loadAgenda();
      }
      if (_historyLoaded) {
        await _loadHistory();
      }
    } catch (_) {
      if (mounted) {
        Toast.showMessage(l10n.devotional_operation_failed, ToastType.error);
      }
    }
  }

  Future<void> _pickSendTime() async {
    final plan = _plan;
    if (plan == null) return;

    final parts = plan.sendTime.split(':');
    final initial =
        parts.length == 2
            ? TimeOfDay(
              hour: int.tryParse(parts[0]) ?? 6,
              minute: int.tryParse(parts[1]) ?? 0,
            )
            : const TimeOfDay(hour: 6, minute: 0);

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null || !mounted) return;

    final value =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

    setState(() {
      _plan = _normalizePlan(plan.copyWith(sendTime: value));
    });
  }

  void _openConfigureTab() {
    if (_tabController.index == _tabConfigure) {
      return;
    }
    _tabController.animateTo(_tabConfigure);
  }

  Future<void> _runLoader({
    required String message,
    required String subtitle,
    required Future<void> Function() action,
  }) async {
    final l10n = context.l10n;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const CircularProgressIndicator(color: AppColors.purple),
                const SizedBox(height: 18),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );

    try {
      await action();
      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();
      Toast.showMessage(l10n.devotional_content_updated, ToastType.success);
    } catch (_) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      rethrow;
    }
  }

  DevotionalPlanModel _normalizePlan(DevotionalPlanModel plan) {
    return normalizePlanDayConfigs(plan, _availableDaysForPlanWeek(plan));
  }

  List<String> _availableDaysForPlanWeek([DevotionalPlanModel? plan]) {
    final effectivePlan = plan ?? _plan;
    return devotionalAvailableDaysForPlanWeek(
      _weekStartDate,
      sendTime: effectivePlan?.sendTime,
      timezone: effectivePlan?.timezone,
    );
  }

  void _toggleDay(String day, bool selected) {
    final plan = _plan;
    if (plan == null) return;

    final availableDays = _availableDaysForPlanWeek();
    if (!availableDays.contains(day)) {
      return;
    }

    final current = [...plan.daysOfWeek];
    if (selected) {
      if (!current.contains(day)) {
        current.add(day);
      }
    } else {
      current.remove(day);
    }

    setState(() {
      _plan = _normalizePlan(plan.copyWith(daysOfWeek: current));
    });
  }

  String _planModeLabel(DevotionalPlanModel plan) {
    return plan.mode == 'review'
        ? context.l10n.devotional_mode_review_title
        : context.l10n.devotional_mode_automatic_title;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _plan == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final plan = _plan!;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.devotional_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 22,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.devotional_subtitle,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 14),
          DevotionalOverviewPanel(
            weekLabel: context.l10n.devotional_week_label(plan.weekStartDate),
            summaryLine:
                _hasExistingPlan
                    ? context.l10n.devotional_summary_line(
                      plan.daysOfWeek.length,
                      devotionalAudienceLabel(context, plan.audience),
                      plan.sendTime,
                      plan.timezone,
                    )
                    : context.l10n.devotional_service_status_subtitle,
            modeLabel: _planModeLabel(plan),
            timezone: plan.timezone,
            configureLabel: context.l10n.devotional_tab_configure,
            totalLabel: context.l10n.devotional_metric_total,
            inReviewLabel: context.l10n.devotional_status_in_review,
            sentLabel: context.l10n.devotional_metric_sent,
            errorLabel: context.l10n.devotional_metric_error,
            total:
                _agenda?.items.length ??
                (_hasExistingPlan ? plan.daysOfWeek.length : 0),
            inReview: _agenda?.inReviewCount ?? 0,
            sent: _history?.sent ?? 0,
            errors: _history?.error ?? 0,
            onConfigure: _openConfigureTab,
          ),
          const SizedBox(height: 12),
          _DevotionalTabs(
            controller: _tabController,
            isScrollable: isMobile(context),
            agendaLabel: context.l10n.devotional_tab_agenda,
            historyLabel: context.l10n.devotional_tab_history,
            configureLabel: context.l10n.devotional_tab_configure,
          ),
          const SizedBox(height: 16),
          _buildSelectedTab(plan),
        ],
      ),
    );
  }

  Widget _buildSelectedTab(DevotionalPlanModel plan) {
    switch (_selectedTab) {
      case _tabAgenda:
        if (!_hasExistingPlan) {
          return DevotionalSetupPrompt(
            title: context.l10n.devotional_service_status_title,
            description: context.l10n.devotional_quick_guide,
            actionLabel: context.l10n.devotional_tab_configure,
            onAction: _openConfigureTab,
          );
        }
        return DevotionalAgendaTab(
          isLoading: _loadingAgenda,
          agenda: _agenda,
          statuses: devotionalStatuses,
          audiences: devotionalAudiences,
          statusFilter: _agendaStatusFilter,
          audienceFilter: _agendaAudienceFilter,
          channelFilter: _agendaChannelFilter,
          onStatusFilterChanged: (value) {
            setState(() => _agendaStatusFilter = value);
          },
          onAudienceFilterChanged: (value) {
            setState(() => _agendaAudienceFilter = value);
          },
          onChannelFilterChanged: (value) {
            setState(() => _agendaChannelFilter = value);
          },
          onApplyFilters: _loadAgenda,
          onOpenDetail: _openReview,
          onRegenerate: _regenerateFromAgenda,
          onRetrySend: _retrySend,
          onViewEngagement: _openCommunityInsights,
          dayLabelBuilder: (day) => devotionalDayLabel(context, day),
          audienceLabelBuilder:
              (audience) => devotionalAudienceLabel(context, audience),
          statusLabelBuilder:
              (status) => devotionalStatusLabel(context, status),
          statusFilterLabel: context.l10n.devotional_agenda_status_filter,
          audienceLabel: context.l10n.devotional_audience,
          channelFilterLabel: context.l10n.devotional_agenda_channel_filter,
          applyFiltersLabel: context.l10n.devotional_apply_filters,
          noAgendaLabel: context.l10n.devotional_no_agenda,
          noTitleLabel: context.l10n.devotional_item_no_title,
          agendaSummaryBuilder: context.l10n.devotional_agenda_summary,
          channelLineBuilder: context.l10n.devotional_item_channel_line,
          lateWarningLabel: context.l10n.devotional_item_urgent_approval,
          viewDetailLabel: context.l10n.devotional_view_detail,
          viewEngagementLabel: context.l10n.devotional_view_engagement,
          regenerateLabel: context.l10n.devotional_regenerate,
          retrySendLabel: context.l10n.devotional_retry_send,
        );
      case _tabHistory:
        return DevotionalHistoryTab(
          isLoading: _loadingHistory,
          history: _history,
          audienceLabelBuilder:
              (audience) => devotionalAudienceLabel(context, audience),
          statusLabelBuilder:
              (status) => devotionalStatusLabel(context, status),
          channelLineBuilder: context.l10n.devotional_item_channel_line,
          totalLabel: context.l10n.devotional_metric_total,
          sentLabel: context.l10n.devotional_metric_sent,
          partialLabel: context.l10n.devotional_metric_partial,
          errorLabel: context.l10n.devotional_metric_error,
          emptyLabel: context.l10n.devotional_history_empty,
        );
      case _tabConfigure:
      default:
        return DevotionalConfigSection(
          plan: plan,
          saving: _savingPlan,
          days: _availableDaysForPlanWeek(),
          onPickSendTime: _pickSendTime,
          onDayToggle: _toggleDay,
          onPlanChanged: (updated) {
            setState(() => _plan = updated);
          },
          onSave: _savePlan,
        );
    }
  }
}

class _DevotionalTabs extends StatelessWidget {
  final TabController controller;
  final bool isScrollable;
  final String agendaLabel;
  final String historyLabel;
  final String configureLabel;

  const _DevotionalTabs({
    required this.controller,
    required this.isScrollable,
    required this.agendaLabel,
    required this.historyLabel,
    required this.configureLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        indicatorColor: AppColors.purple,
        labelColor: AppColors.purple,
        unselectedLabelColor: AppColors.grey,
        labelStyle: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(text: agendaLabel),
          Tab(text: historyLabel),
          Tab(text: configureLabel),
        ],
      ),
    );
  }
}
