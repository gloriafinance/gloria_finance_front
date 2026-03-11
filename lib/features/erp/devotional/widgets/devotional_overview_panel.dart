import 'package:flutter/material.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';

class DevotionalOverviewPanel extends StatelessWidget {
  final String weekLabel;
  final String summaryLine;
  final String modeLabel;
  final String timezone;
  final String configureLabel;
  final String totalLabel;
  final String inReviewLabel;
  final String sentLabel;
  final String errorLabel;
  final int total;
  final int inReview;
  final int sent;
  final int errors;
  final VoidCallback onConfigure;

  const DevotionalOverviewPanel({
    super.key,
    required this.weekLabel,
    required this.summaryLine,
    required this.modeLabel,
    required this.timezone,
    required this.configureLabel,
    required this.totalLabel,
    required this.inReviewLabel,
    required this.sentLabel,
    required this.errorLabel,
    required this.total,
    required this.inReview,
    required this.sent,
    required this.errors,
    required this.onConfigure,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mobile) ...[
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: configureLabel,
                icon: Icons.settings_outlined,
                backgroundColor: AppColors.purple,
                textColor: Colors.white,
                onPressed: onConfigure,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              weekLabel,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: Text(
                    weekLabel,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 230,
                  child: CustomButton(
                    text: configureLabel,
                    icon: Icons.settings_outlined,
                    backgroundColor: AppColors.purple,
                    textColor: Colors.white,
                    onPressed: onConfigure,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 4),
          Text(
            summaryLine,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$modeLabel · $timezone',
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetricChip(label: totalLabel, value: total.toString()),
              _MetricChip(label: inReviewLabel, value: inReview.toString()),
              _MetricChip(label: sentLabel, value: sent.toString()),
              _MetricChip(label: errorLabel, value: errors.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;

  const _MetricChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              color: AppColors.black,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
