import 'package:flutter/material.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/features/erp/devotional/models/devotional_models.dart';

import 'devotional_status_badge.dart';

class DevotionalHistoryTab extends StatelessWidget {
  final bool isLoading;
  final DevotionalHistoryResponseModel? history;
  final String Function(String) audienceLabelBuilder;
  final String Function(String) statusLabelBuilder;
  final String Function(String audience, String push, String whatsapp)
  channelLineBuilder;
  final String totalLabel;
  final String sentLabel;
  final String partialLabel;
  final String errorLabel;
  final String emptyLabel;

  const DevotionalHistoryTab({
    super.key,
    required this.isLoading,
    required this.history,
    required this.audienceLabelBuilder,
    required this.statusLabelBuilder,
    required this.channelLineBuilder,
    required this.totalLabel,
    required this.sentLabel,
    required this.partialLabel,
    required this.errorLabel,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
        if (!isLoading && history != null)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SizedBox(
                width: 210,
                child: _MetricCard(
                  label: totalLabel,
                  value: history!.total.toString(),
                ),
              ),
              SizedBox(
                width: 210,
                child: _MetricCard(
                  label: sentLabel,
                  value: history!.sent.toString(),
                ),
              ),
              SizedBox(
                width: 210,
                child: _MetricCard(
                  label: partialLabel,
                  value: history!.partial.toString(),
                ),
              ),
              SizedBox(
                width: 210,
                child: _MetricCard(
                  label: errorLabel,
                  value: history!.error.toString(),
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        if (!isLoading && (history == null || history!.items.isEmpty))
          Text(
            emptyLabel,
            style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
        if (!isLoading && history != null)
          Column(
            children:
                history!.items.map((item) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
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
                                item.title.isNotEmpty
                                    ? item.title
                                    : item.themeWeek,
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontTitle,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            DevotionalStatusBadge(
                              status: item.overall,
                              label: statusLabelBuilder(item.overall),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          channelLineBuilder(
                            audienceLabelBuilder(item.audience),
                            statusLabelBuilder(item.push),
                            statusLabelBuilder(item.whatsapp),
                          ),
                          style: const TextStyle(
                            fontFamily: AppFonts.fontSubTitle,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
