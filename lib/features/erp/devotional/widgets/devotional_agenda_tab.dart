import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/features/erp/devotional/models/devotional_models.dart';

import 'devotional_status_badge.dart';

class DevotionalAgendaTab extends StatelessWidget {
  final bool isLoading;
  final DevotionalAgendaResponseModel? agenda;
  final List<String> statuses;
  final List<String> audiences;
  final String statusFilter;
  final String audienceFilter;
  final String channelFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final ValueChanged<String> onAudienceFilterChanged;
  final ValueChanged<String> onChannelFilterChanged;
  final VoidCallback onApplyFilters;
  final void Function(DevotionalAgendaItemModel item) onOpenDetail;
  final ValueChanged<String> onRegenerate;
  final ValueChanged<String> onRetrySend;
  final String Function(String) dayLabelBuilder;
  final String Function(String) audienceLabelBuilder;
  final String Function(String) statusLabelBuilder;
  final String statusFilterLabel;
  final String audienceLabel;
  final String channelFilterLabel;
  final String applyFiltersLabel;
  final String noAgendaLabel;
  final String noTitleLabel;
  final String Function(String nextSend, int inReview) agendaSummaryBuilder;
  final String Function(String audience, String push, String whatsapp)
  channelLineBuilder;
  final String lateWarningLabel;
  final String viewDetailLabel;
  final String regenerateLabel;
  final String retrySendLabel;

  const DevotionalAgendaTab({
    super.key,
    required this.isLoading,
    required this.agenda,
    required this.statuses,
    required this.audiences,
    required this.statusFilter,
    required this.audienceFilter,
    required this.channelFilter,
    required this.onStatusFilterChanged,
    required this.onAudienceFilterChanged,
    required this.onChannelFilterChanged,
    required this.onApplyFilters,
    required this.onOpenDetail,
    required this.onRegenerate,
    required this.onRetrySend,
    required this.dayLabelBuilder,
    required this.audienceLabelBuilder,
    required this.statusLabelBuilder,
    required this.statusFilterLabel,
    required this.audienceLabel,
    required this.channelFilterLabel,
    required this.applyFiltersLabel,
    required this.noAgendaLabel,
    required this.noTitleLabel,
    required this.agendaSummaryBuilder,
    required this.channelLineBuilder,
    required this.lateWarningLabel,
    required this.viewDetailLabel,
    required this.regenerateLabel,
    required this.retrySendLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AgendaFilters(
          statuses: statuses,
          audiences: audiences,
          statusFilter: statusFilter,
          audienceFilter: audienceFilter,
          channelFilter: channelFilter,
          onStatusFilterChanged: onStatusFilterChanged,
          onAudienceFilterChanged: onAudienceFilterChanged,
          onChannelFilterChanged: onChannelFilterChanged,
          onApplyFilters: onApplyFilters,
          statusLabelBuilder: statusLabelBuilder,
          audienceLabelBuilder: audienceLabelBuilder,
          statusFilterLabel: statusFilterLabel,
          audienceLabel: audienceLabel,
          channelFilterLabel: channelFilterLabel,
          applyFiltersLabel: applyFiltersLabel,
        ),
        const SizedBox(height: 12),
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
        if (!isLoading && agenda != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xfff8f8fb),
            ),
            child: Text(
              agendaSummaryBuilder(
                agenda!.nextSendAt != null
                    ? DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(agenda!.nextSendAt!.toLocal())
                    : 'N/A',
                agenda!.inReviewCount,
              ),
              style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
            ),
          ),
        const SizedBox(height: 12),
        if (!isLoading && (agenda == null || agenda!.items.isEmpty))
          Text(
            noAgendaLabel,
            style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
        if (!isLoading && agenda != null)
          Column(
            children:
                agenda!.items.map((item) {
                  return _AgendaCard(
                    item: item,
                    dayLabelBuilder: dayLabelBuilder,
                    audienceLabelBuilder: audienceLabelBuilder,
                    statusLabelBuilder: statusLabelBuilder,
                    channelLineBuilder: channelLineBuilder,
                    noTitleLabel: noTitleLabel,
                    lateWarningLabel: lateWarningLabel,
                    viewDetailLabel: viewDetailLabel,
                    regenerateLabel: regenerateLabel,
                    retrySendLabel: retrySendLabel,
                    onOpenDetail: onOpenDetail,
                    onRegenerate: onRegenerate,
                    onRetrySend: onRetrySend,
                  );
                }).toList(),
          ),
      ],
    );
  }
}

class _AgendaFilters extends StatelessWidget {
  final List<String> statuses;
  final List<String> audiences;
  final String statusFilter;
  final String audienceFilter;
  final String channelFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final ValueChanged<String> onAudienceFilterChanged;
  final ValueChanged<String> onChannelFilterChanged;
  final VoidCallback onApplyFilters;
  final String Function(String) statusLabelBuilder;
  final String Function(String) audienceLabelBuilder;
  final String statusFilterLabel;
  final String audienceLabel;
  final String channelFilterLabel;
  final String applyFiltersLabel;

  const _AgendaFilters({
    required this.statuses,
    required this.audiences,
    required this.statusFilter,
    required this.audienceFilter,
    required this.channelFilter,
    required this.onStatusFilterChanged,
    required this.onAudienceFilterChanged,
    required this.onChannelFilterChanged,
    required this.onApplyFilters,
    required this.statusLabelBuilder,
    required this.audienceLabelBuilder,
    required this.statusFilterLabel,
    required this.audienceLabel,
    required this.channelFilterLabel,
    required this.applyFiltersLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return Column(
        children: [
          Dropdown(
            label: statusFilterLabel,
            items: statuses,
            initialValue: statusFilter.isEmpty ? null : statusFilter,
            itemLabelBuilder: statusLabelBuilder,
            searchHint: '',
            onChanged: onStatusFilterChanged,
          ),
          Dropdown(
            label: audienceLabel,
            items: audiences,
            initialValue: audienceFilter.isEmpty ? null : audienceFilter,
            itemLabelBuilder: audienceLabelBuilder,
            searchHint: '',
            onChanged: onAudienceFilterChanged,
          ),
          Dropdown(
            label: channelFilterLabel,
            items: const ['push', 'whatsapp'],
            initialValue: channelFilter.isEmpty ? null : channelFilter,
            searchHint: '',
            onChanged: onChannelFilterChanged,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: applyFiltersLabel,
              backgroundColor: AppColors.blue,
              textColor: Colors.white,
              icon: Icons.search,
              padding: const EdgeInsets.symmetric(vertical: 12),
              onPressed: onApplyFilters,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Dropdown(
            label: statusFilterLabel,
            items: statuses,
            initialValue: statusFilter.isEmpty ? null : statusFilter,
            itemLabelBuilder: statusLabelBuilder,
            searchHint: '',
            onChanged: onStatusFilterChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Dropdown(
            label: audienceLabel,
            items: audiences,
            initialValue: audienceFilter.isEmpty ? null : audienceFilter,
            itemLabelBuilder: audienceLabelBuilder,
            searchHint: '',
            onChanged: onAudienceFilterChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Dropdown(
            label: channelFilterLabel,
            items: const ['push', 'whatsapp'],
            initialValue: channelFilter.isEmpty ? null : channelFilter,
            searchHint: '',
            onChanged: onChannelFilterChanged,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          margin: const EdgeInsets.only(top: 48),
          child: ButtonActionTable(
            color: AppColors.blue,
            text: applyFiltersLabel,
            icon: Icons.search,
            onPressed: onApplyFilters,
          ),
        ),
      ],
    );
  }
}

class _AgendaCard extends StatelessWidget {
  final DevotionalAgendaItemModel item;
  final String Function(String) dayLabelBuilder;
  final String Function(String) audienceLabelBuilder;
  final String Function(String) statusLabelBuilder;
  final String Function(String audience, String push, String whatsapp)
  channelLineBuilder;
  final String noTitleLabel;
  final String lateWarningLabel;
  final String viewDetailLabel;
  final String regenerateLabel;
  final String retrySendLabel;
  final void Function(DevotionalAgendaItemModel item) onOpenDetail;
  final ValueChanged<String> onRegenerate;
  final ValueChanged<String> onRetrySend;

  const _AgendaCard({
    required this.item,
    required this.dayLabelBuilder,
    required this.audienceLabelBuilder,
    required this.statusLabelBuilder,
    required this.channelLineBuilder,
    required this.noTitleLabel,
    required this.lateWarningLabel,
    required this.viewDetailLabel,
    required this.regenerateLabel,
    required this.retrySendLabel,
    required this.onOpenDetail,
    required this.onRegenerate,
    required this.onRetrySend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
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
                  item.title?.isNotEmpty == true ? item.title! : noTitleLabel,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 16,
                  ),
                ),
              ),
              DevotionalStatusBadge(
                status: item.status,
                label: statusLabelBuilder(item.status),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${dayLabelBuilder(item.dayOfWeek)} - ${item.scheduleDate} ${item.scheduledAt != null ? DateFormat('HH:mm').format(item.scheduledAt!.toLocal()) : ''}',
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            channelLineBuilder(
              audienceLabelBuilder(item.audience),
              statusLabelBuilder(item.pushResult),
              statusLabelBuilder(item.whatsappResult),
            ),
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
            ),
          ),
          if (item.isLate)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                lateWarningLabel,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  color: Colors.red,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ButtonActionTable(
                color: AppColors.purple,
                text: viewDetailLabel,
                icon: Icons.visibility,
                onPressed: () => onOpenDetail(item),
              ),
              if (item.status != 'sent' && item.status != 'sending')
                ButtonActionTable(
                  color: AppColors.mustard,
                  text: regenerateLabel,
                  icon: Icons.auto_awesome,
                  onPressed: () => onRegenerate(item.devotionalId),
                ),
              if (item.status == 'failed')
                ButtonActionTable(
                  color: AppColors.blue,
                  text: retrySendLabel,
                  icon: Icons.refresh,
                  onPressed: () => onRetrySend(item.devotionalId),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
