import 'package:flutter/material.dart';

import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/devotional/models/devotional_models.dart';
import 'package:gloria_finance/features/erp/devotional/utils/devotional_screen_utils.dart';
import 'package:gloria_finance/features/erp/devotional/widgets/devotional_config_tab.dart';

class DevotionalConfigSection extends StatelessWidget {
  final DevotionalPlanModel plan;
  final bool saving;
  final List<String> days;
  final VoidCallback onPickSendTime;
  final void Function(String day, bool selected) onDayToggle;
  final ValueChanged<DevotionalPlanModel> onPlanChanged;
  final VoidCallback onSave;

  const DevotionalConfigSection({
    super.key,
    required this.plan,
    required this.saving,
    required this.days,
    required this.onPickSendTime,
    required this.onDayToggle,
    required this.onPlanChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return DevotionalConfigTab(
      plan: plan,
      saving: saving,
      days: days,
      audiences: devotionalAudiences,
      tones: devotionalTones,
      dayLabelBuilder: (day) => devotionalDayLabel(context, day),
      audienceLabelBuilder:
          (audience) => devotionalAudienceLabel(context, audience),
      toneTitleBuilder: (tone) => devotionalToneTitle(context, tone),
      toneSubtitleBuilder: (tone) => devotionalToneSubtitle(context, tone),
      onPickSendTime: onPickSendTime,
      onEnabledChanged: (value) {
        onPlanChanged(plan.copyWith(isEnabled: value));
      },
      onThemeChanged: (value) {
        onPlanChanged(plan.copyWith(themeWeek: value));
      },
      onAudienceChanged: (value) {
        onPlanChanged(plan.copyWith(audience: value));
      },
      onModeChanged: (value) {
        onPlanChanged(plan.copyWith(mode: value));
      },
      onPushChanged: (value) {
        onPlanChanged(
          plan.copyWith(channels: plan.channels.copyWith(pushEnabled: value)),
        );
      },
      onWhatsappChanged: (value) {
        onPlanChanged(
          plan.copyWith(
            channels: plan.channels.copyWith(whatsappEnabled: value),
          ),
        );
      },
      onDayToggle: onDayToggle,
      onDayTitleChanged: (day, value) {
        final config = _dayConfigFor(plan, day);
        onPlanChanged(
          plan.copyWith(
            dayConfigs: _upsertDayConfig(
              plan.dayConfigs,
              config.copyWith(titleHint: value),
            ),
          ),
        );
      },
      onDayContextChanged: (day, value) {
        final config = _dayConfigFor(plan, day);
        onPlanChanged(
          plan.copyWith(
            dayConfigs: _upsertDayConfig(
              plan.dayConfigs,
              config.copyWith(biblicalContext: value),
            ),
          ),
        );
      },
      onDayToneChanged: (day, tone) {
        final config = _dayConfigFor(plan, day);
        onPlanChanged(
          plan.copyWith(
            dayConfigs: _upsertDayConfig(
              plan.dayConfigs,
              config.copyWith(tone: tone),
            ),
          ),
        );
      },
      onSave: onSave,
      saveButtonText:
          saving
              ? context.l10n.devotional_saving
              : context.l10n.devotional_save_configuration,
      summaryTitle: context.l10n.devotional_week_label(plan.weekStartDate),
      summaryText: context.l10n.devotional_summary_line(
        plan.daysOfWeek.length,
        devotionalAudienceLabel(context, plan.audience),
        plan.sendTime,
        plan.timezone,
      ),
      quickGuideText: context.l10n.devotional_quick_guide,
      reviewHint:
          plan.mode == 'review'
              ? context.l10n.devotional_review_mode_hint
              : null,
      serviceTitle: context.l10n.devotional_service_status_title,
      serviceSubtitle: context.l10n.devotional_service_status_subtitle,
      themeLabel: context.l10n.devotional_theme_week,
      sendTimeLabel: context.l10n.devotional_send_time,
      timezoneHint: context.l10n.devotional_timezone_hint(plan.timezone),
      audienceLabel: context.l10n.devotional_audience,
      operationModeLabel: context.l10n.devotional_operation_mode,
      automaticModeTitle: context.l10n.devotional_mode_automatic_title,
      automaticModeSubtitle: context.l10n.devotional_mode_automatic_subtitle,
      reviewModeTitle: context.l10n.devotional_mode_review_title,
      reviewModeSubtitle: context.l10n.devotional_mode_review_subtitle,
      pushLabel: context.l10n.devotional_channel_push,
      pushSubtitle: context.l10n.devotional_channel_push_subtitle,
      whatsappLabel: context.l10n.devotional_channel_whatsapp,
      whatsappSubtitle: context.l10n.devotional_channel_whatsapp_subtitle,
      daysLabel: context.l10n.devotional_days_of_week,
      dayConfigLabel: context.l10n.devotional_day_config,
      dayTitleHintLabel: context.l10n.devotional_day_title_hint,
      dayBiblicalContextLabel: context.l10n.devotional_day_biblical_context,
      dayToneLabel: context.l10n.devotional_day_tone,
      dayCompleteLabel: context.l10n.devotional_day_complete,
      dayIncompleteLabel: context.l10n.devotional_day_incomplete,
    );
  }

  DevotionalDayConfigModel _dayConfigFor(DevotionalPlanModel plan, String day) {
    return plan.dayConfigs.firstWhere(
      (item) => item.dayOfWeek == day,
      orElse:
          () => DevotionalDayConfigModel(
            dayOfWeek: day,
            titleHint: '',
            biblicalContext: '',
            tone: 'pastoral',
          ),
    );
  }

  List<DevotionalDayConfigModel> _upsertDayConfig(
    List<DevotionalDayConfigModel> current,
    DevotionalDayConfigModel incoming,
  ) {
    final list = [...current];
    final index = list.indexWhere(
      (item) => item.dayOfWeek == incoming.dayOfWeek,
    );
    if (index >= 0) {
      list[index] = incoming;
    } else {
      list.add(incoming);
    }
    return list;
  }
}
