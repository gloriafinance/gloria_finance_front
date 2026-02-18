import 'package:flutter/material.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/features/erp/devotional/models/devotional_models.dart';

import 'devotional_mode_selector.dart';
import 'devotional_tone_selector.dart';

class DevotionalConfigTab extends StatelessWidget {
  final DevotionalPlanModel plan;
  final bool saving;
  final List<String> days;
  final List<String> audiences;
  final List<String> tones;
  final String Function(String) dayLabelBuilder;
  final String Function(String) audienceLabelBuilder;
  final String Function(String) toneTitleBuilder;
  final String Function(String) toneSubtitleBuilder;
  final VoidCallback onPickSendTime;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<String> onAudienceChanged;
  final ValueChanged<String> onModeChanged;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onWhatsappChanged;
  final void Function(String day, bool selected) onDayToggle;
  final void Function(String day, String value) onDayTitleChanged;
  final void Function(String day, String value) onDayContextChanged;
  final void Function(String day, String tone) onDayToneChanged;
  final VoidCallback onSave;
  final String saveButtonText;
  final String summaryTitle;
  final String summaryText;
  final String quickGuideText;
  final String? reviewHint;
  final String serviceTitle;
  final String serviceSubtitle;
  final String themeLabel;
  final String sendTimeLabel;
  final String timezoneHint;
  final String audienceLabel;
  final String operationModeLabel;
  final String automaticModeTitle;
  final String automaticModeSubtitle;
  final String reviewModeTitle;
  final String reviewModeSubtitle;
  final String pushLabel;
  final String pushSubtitle;
  final String whatsappLabel;
  final String whatsappSubtitle;
  final String daysLabel;
  final String dayConfigLabel;
  final String dayTitleHintLabel;
  final String dayBiblicalContextLabel;
  final String dayToneLabel;
  final String dayCompleteLabel;
  final String dayIncompleteLabel;

  const DevotionalConfigTab({
    super.key,
    required this.plan,
    required this.saving,
    required this.days,
    required this.audiences,
    required this.tones,
    required this.dayLabelBuilder,
    required this.audienceLabelBuilder,
    required this.toneTitleBuilder,
    required this.toneSubtitleBuilder,
    required this.onPickSendTime,
    required this.onEnabledChanged,
    required this.onThemeChanged,
    required this.onAudienceChanged,
    required this.onModeChanged,
    required this.onPushChanged,
    required this.onWhatsappChanged,
    required this.onDayToggle,
    required this.onDayTitleChanged,
    required this.onDayContextChanged,
    required this.onDayToneChanged,
    required this.onSave,
    required this.saveButtonText,
    required this.summaryTitle,
    required this.summaryText,
    required this.quickGuideText,
    required this.reviewHint,
    required this.serviceTitle,
    required this.serviceSubtitle,
    required this.themeLabel,
    required this.sendTimeLabel,
    required this.timezoneHint,
    required this.audienceLabel,
    required this.operationModeLabel,
    required this.automaticModeTitle,
    required this.automaticModeSubtitle,
    required this.reviewModeTitle,
    required this.reviewModeSubtitle,
    required this.pushLabel,
    required this.pushSubtitle,
    required this.whatsappLabel,
    required this.whatsappSubtitle,
    required this.daysLabel,
    required this.dayConfigLabel,
    required this.dayTitleHintLabel,
    required this.dayBiblicalContextLabel,
    required this.dayToneLabel,
    required this.dayCompleteLabel,
    required this.dayIncompleteLabel,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryCard(
          title: summaryTitle,
          text: summaryText,
          reviewHint: reviewHint,
        ),
        const SizedBox(height: 8),
        _QuickGuideCard(text: quickGuideText),
        const SizedBox(height: 12),
        if (mobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                value: plan.isEnabled,
                onChanged: onEnabledChanged,
                title: Text(
                  serviceTitle,
                  style: const TextStyle(fontFamily: AppFonts.fontTitle),
                ),
                subtitle: Text(
                  serviceSubtitle,
                  style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
                ),
              ),
              Input(
                key: const ValueKey('devotional-theme'),
                label: themeLabel,
                initialValue: plan.themeWeek,
                onChanged: onThemeChanged,
              ),
              Input(
                key: const ValueKey('devotional-send-time'),
                label: sendTimeLabel,
                initialValue: plan.sendTime,
                readOnly: true,
                onTap: onPickSendTime,
                onChanged: (_) {},
              ),
              const SizedBox(height: 4),
              Text(
                timezoneHint,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  color: AppColors.grey,
                ),
              ),
              Dropdown(
                label: audienceLabel,
                items: audiences,
                initialValue: plan.audience,
                itemLabelBuilder: audienceLabelBuilder,
                searchHint: '',
                onChanged: onAudienceChanged,
              ),
              const SizedBox(height: 16),
              DevotionalModeSelector(
                selectedMode: plan.mode,
                onChanged: onModeChanged,
                title: operationModeLabel,
                automaticTitle: automaticModeTitle,
                automaticSubtitle: automaticModeSubtitle,
                reviewTitle: reviewModeTitle,
                reviewSubtitle: reviewModeSubtitle,
              ),
              const SizedBox(height: 14),
              SwitchListTile(
                value: plan.channels.pushEnabled,
                onChanged: onPushChanged,
                title: Text(
                  pushLabel,
                  style: const TextStyle(fontFamily: AppFonts.fontTitle),
                ),
                subtitle: Text(
                  pushSubtitle,
                  style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
                ),
              ),
              SwitchListTile(
                value: plan.channels.whatsappEnabled,
                onChanged: onWhatsappChanged,
                title: Text(
                  whatsappLabel,
                  style: const TextStyle(fontFamily: AppFonts.fontTitle),
                ),
                subtitle: Text(
                  whatsappSubtitle,
                  style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
                ),
              ),
            ],
          ),
        if (!mobile)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _ConfigSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: plan.isEnabled,
                        onChanged: onEnabledChanged,
                        title: Text(
                          serviceTitle,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontTitle,
                          ),
                        ),
                        subtitle: Text(
                          serviceSubtitle,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontSubTitle,
                          ),
                        ),
                      ),
                      Input(
                        key: const ValueKey('devotional-theme'),
                        label: themeLabel,
                        initialValue: plan.themeWeek,
                        onChanged: onThemeChanged,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Input(
                              key: const ValueKey('devotional-send-time'),
                              label: sendTimeLabel,
                              initialValue: plan.sendTime,
                              readOnly: true,
                              onTap: onPickSendTime,
                              onChanged: (_) {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Dropdown(
                              label: audienceLabel,
                              items: audiences,
                              initialValue: plan.audience,
                              itemLabelBuilder: audienceLabelBuilder,
                              searchHint: '',
                              onChanged: onAudienceChanged,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timezoneHint,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _ConfigSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DevotionalModeSelector(
                        selectedMode: plan.mode,
                        onChanged: onModeChanged,
                        title: operationModeLabel,
                        automaticTitle: automaticModeTitle,
                        automaticSubtitle: automaticModeSubtitle,
                        reviewTitle: reviewModeTitle,
                        reviewSubtitle: reviewModeSubtitle,
                      ),
                      const SizedBox(height: 14),
                      _ChannelToggleRow(
                        label: pushLabel,
                        subtitle: pushSubtitle,
                        value: plan.channels.pushEnabled,
                        onChanged: onPushChanged,
                      ),
                      const SizedBox(height: 8),
                      _ChannelToggleRow(
                        label: whatsappLabel,
                        subtitle: whatsappSubtitle,
                        value: plan.channels.whatsappEnabled,
                        onChanged: onWhatsappChanged,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        const SizedBox(height: 6),
        Text(
          daysLabel,
          style: const TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              days.map((day) {
                final selected = plan.daysOfWeek.contains(day);
                return FilterChip(
                  selected: selected,
                  label: Text(dayLabelBuilder(day)),
                  onSelected: (value) => onDayToggle(day, value),
                );
              }).toList(),
        ),
        const SizedBox(height: 14),
        Text(
          dayConfigLabel,
          style: const TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 15),
        ),
        const SizedBox(height: 8),
        _DayConfigGrid(
          daysOfWeek: plan.daysOfWeek,
          dayConfigs: plan.dayConfigs,
          tones: tones,
          dayLabelBuilder: dayLabelBuilder,
          toneTitleBuilder: toneTitleBuilder,
          toneSubtitleBuilder: toneSubtitleBuilder,
          onTitleChanged: onDayTitleChanged,
          onContextChanged: onDayContextChanged,
          onToneChanged: onDayToneChanged,
          titleHintLabel: dayTitleHintLabel,
          biblicalContextLabel: dayBiblicalContextLabel,
          toneLabel: dayToneLabel,
          completeLabel: dayCompleteLabel,
          incompleteLabel: dayIncompleteLabel,
        ),
        const SizedBox(height: 14),
        if (mobile)
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: saveButtonText,
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onPressed: saving ? null : onSave,
                ),
              ),
            ],
          ),
        if (!mobile)
          Row(
            children: [
              const Spacer(),
              SizedBox(
                width: 290,
                child: CustomButton(
                  text: saveButtonText,
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  onPressed: saving ? null : onSave,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _ConfigSectionCard extends StatelessWidget {
  final Widget child;

  const _ConfigSectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
        color: Colors.white,
      ),
      child: child,
    );
  }
}

class _ChannelToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ChannelToggleRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String text;
  final String? reviewHint;

  const _SummaryCard({
    required this.title,
    required this.text,
    required this.reviewHint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xfff8f5fc),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontFamily: AppFonts.fontTitle)),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(fontFamily: AppFonts.fontSubTitle)),
          if (reviewHint != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                reviewHint!,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  color: AppColors.purple,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickGuideCard extends StatelessWidget {
  final String text;

  const _QuickGuideCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xfff8f8fb),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.info_outline, size: 18, color: AppColors.purple),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: AppColors.grey,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayConfigGrid extends StatelessWidget {
  final List<String> daysOfWeek;
  final List<DevotionalDayConfigModel> dayConfigs;
  final List<String> tones;
  final String Function(String) dayLabelBuilder;
  final String Function(String) toneTitleBuilder;
  final String Function(String) toneSubtitleBuilder;
  final void Function(String day, String value) onTitleChanged;
  final void Function(String day, String value) onContextChanged;
  final void Function(String day, String tone) onToneChanged;
  final String titleHintLabel;
  final String biblicalContextLabel;
  final String toneLabel;
  final String completeLabel;
  final String incompleteLabel;

  const _DayConfigGrid({
    required this.daysOfWeek,
    required this.dayConfigs,
    required this.tones,
    required this.dayLabelBuilder,
    required this.toneTitleBuilder,
    required this.toneSubtitleBuilder,
    required this.onTitleChanged,
    required this.onContextChanged,
    required this.onToneChanged,
    required this.titleHintLabel,
    required this.biblicalContextLabel,
    required this.toneLabel,
    required this.completeLabel,
    required this.incompleteLabel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = MediaQuery.of(context).size.width >= 768;
        final spacing = 12.0;
        final columns = isDesktop ? 3 : 1;
        final maxWidth =
            constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;
        final cardWidth = (maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children:
              daysOfWeek.map((day) {
                final config = dayConfigs.firstWhere(
                  (cfg) => cfg.dayOfWeek == day,
                  orElse:
                      () => DevotionalDayConfigModel(
                        dayOfWeek: day,
                        titleHint: '',
                        biblicalContext: '',
                        tone: 'pastoral',
                      ),
                );

                return SizedBox(
                  width: cardWidth,
                  child: _DayConfigCard(
                    day: day,
                    config: config,
                    tones: tones,
                    dayLabelBuilder: dayLabelBuilder,
                    toneTitleBuilder: toneTitleBuilder,
                    toneSubtitleBuilder: toneSubtitleBuilder,
                    onTitleChanged: onTitleChanged,
                    onContextChanged: onContextChanged,
                    onToneChanged: onToneChanged,
                    titleHintLabel: titleHintLabel,
                    biblicalContextLabel: biblicalContextLabel,
                    toneLabel: toneLabel,
                    completeLabel: completeLabel,
                    incompleteLabel: incompleteLabel,
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}

class _DayConfigCard extends StatelessWidget {
  final String day;
  final DevotionalDayConfigModel config;
  final List<String> tones;
  final String Function(String) dayLabelBuilder;
  final String Function(String) toneTitleBuilder;
  final String Function(String) toneSubtitleBuilder;
  final void Function(String day, String value) onTitleChanged;
  final void Function(String day, String value) onContextChanged;
  final void Function(String day, String tone) onToneChanged;
  final String titleHintLabel;
  final String biblicalContextLabel;
  final String toneLabel;
  final String completeLabel;
  final String incompleteLabel;

  const _DayConfigCard({
    required this.day,
    required this.config,
    required this.tones,
    required this.dayLabelBuilder,
    required this.toneTitleBuilder,
    required this.toneSubtitleBuilder,
    required this.onTitleChanged,
    required this.onContextChanged,
    required this.onToneChanged,
    required this.titleHintLabel,
    required this.biblicalContextLabel,
    required this.toneLabel,
    required this.completeLabel,
    required this.incompleteLabel,
  });

  @override
  Widget build(BuildContext context) {
    final complete =
        config.titleHint.trim().isNotEmpty &&
        config.biblicalContext.trim().isNotEmpty &&
        config.tone.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  dayLabelBuilder(day),
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      complete ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  complete ? completeLabel : incompleteLabel,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Input(
            key: ValueKey('title-$day'),
            label: titleHintLabel,
            initialValue: config.titleHint,
            onChanged: (value) => onTitleChanged(day, value),
          ),
          Input(
            key: ValueKey('context-$day'),
            label: biblicalContextLabel,
            maxLines: 4,
            initialValue: config.biblicalContext,
            onChanged: (value) => onContextChanged(day, value),
          ),
          const SizedBox(height: 8),
          Text(
            toneLabel,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          DevotionalToneSelector(
            tones: tones,
            selectedTone: config.tone,
            onSelect: (tone) => onToneChanged(day, tone),
            titleBuilder: toneTitleBuilder,
            subtitleBuilder: toneSubtitleBuilder,
          ),
        ],
      ),
    );
  }
}
