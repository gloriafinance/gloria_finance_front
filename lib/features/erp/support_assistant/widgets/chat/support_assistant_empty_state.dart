import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

class SupportAssistantEmptyState extends StatelessWidget {
  const SupportAssistantEmptyState({
    super.key,
    required this.isCompact,
    required this.onSuggestionSelected,
  });

  final bool isCompact;
  final ValueChanged<String> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.greyLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.greyLight),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                context.l10n.support_assistant_empty_intro,
                style: TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: isCompact ? 15 : 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.support_assistant_empty_suggestions,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _SupportSuggestionChip(
                    text: context.l10n.support_assistant_suggestion_overview,
                    onPressed: onSuggestionSelected,
                  ),
                  _SupportSuggestionChip(
                    text:
                        context.l10n.support_assistant_suggestion_paid_expense,
                    onPressed: onSuggestionSelected,
                  ),
                  _SupportSuggestionChip(
                    text:
                        context
                            .l10n
                            .support_assistant_suggestion_accounts_payable,
                    onPressed: onSuggestionSelected,
                  ),
                  _SupportSuggestionChip(
                    text:
                        context.l10n.support_assistant_suggestion_analyze_image,
                    onPressed: onSuggestionSelected,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SupportSuggestionChip extends StatelessWidget {
  const _SupportSuggestionChip({required this.text, required this.onPressed});

  final String text;
  final ValueChanged<String> onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(text), onPressed: () => onPressed(text));
  }
}
