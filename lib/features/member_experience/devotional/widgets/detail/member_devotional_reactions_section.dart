import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/devotional/widgets/detail/member_devotional_detail_sections.dart';

class MemberDevotionalReactionsSection extends StatelessWidget {
  final bool isUpdating;
  final int totalReactions;
  final String? selectedReaction;
  final Map<String, int> reactionCounts;
  final ValueChanged<String> onToggleReaction;

  const MemberDevotionalReactionsSection({
    super.key,
    required this.isUpdating,
    required this.totalReactions,
    required this.selectedReaction,
    required this.reactionCounts,
    required this.onToggleReaction,
  });

  @override
  Widget build(BuildContext context) {
    final options = reactionOptions(context);
    final selectedOption =
        selectedReaction == null
            ? null
            : options
                .where((option) => option.id == selectedReaction)
                .firstOrNull;

    return MemberDevotionalSectionCard(
      tone: MemberDevotionalSectionTone.tinted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MemberDevotionalEditorialSectionHeader(
            title: context.l10n.member_devotional_detail_reactions_title,
            subtitle: context.l10n.member_devotional_detail_reactions_hint,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReactionTriggerButton(
                  option: selectedOption,
                  isUpdating: isUpdating,
                  onTap: () => _showReactionPicker(context, options),
                  onLongPress: () => _showReactionPicker(context, options),
                ),
              ),
              const SizedBox(width: 10),
              MemberDevotionalCountPill(
                label:
                    '$totalReactions ${context.l10n.member_home_devotional_moment_reactions}',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            selectedOption == null
                ? context.l10n.member_devotional_detail_reactions_cta_hint
                : context.l10n.member_devotional_detail_reactions_selected_hint(
                  selectedOption.label,
                ),
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 12.5,
              height: 1.45,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showReactionPicker(
    BuildContext context,
    List<MemberDevotionalReactionOption> options,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(16),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  context.l10n.member_devotional_detail_reactions_picker_title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        options
                            .map(
                              (option) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: _ReactionPickerItem(
                                  option: option,
                                  count: reactionCounts[option.id] ?? 0,
                                  isSelected: selectedReaction == option.id,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    onToggleReaction(option.id);
                                  },
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                if (selectedReaction != null) ...[
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onToggleReaction(selectedReaction!);
                    },
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                    label: Text(
                      context.l10n.member_devotional_detail_reactions_remove,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

List<MemberDevotionalReactionOption> reactionOptions(BuildContext context) {
  final l10n = context.l10n;
  return [
    MemberDevotionalReactionOption(
      id: 'edified',
      emoji: '✨',
      label: l10n.member_devotional_reaction_edified,
    ),
    MemberDevotionalReactionOption(
      id: 'amen',
      emoji: '🙏',
      label: l10n.member_devotional_reaction_amen,
    ),
    MemberDevotionalReactionOption(
      id: 'challenged',
      emoji: '🔥',
      label: l10n.member_devotional_reaction_challenged,
    ),
    MemberDevotionalReactionOption(
      id: 'peace',
      emoji: '🕊️',
      label: l10n.member_devotional_reaction_peace,
    ),
    MemberDevotionalReactionOption(
      id: 'reflect',
      emoji: '🤍',
      label: l10n.member_devotional_reaction_reflect,
    ),
  ];
}

class MemberDevotionalReactionOption {
  final String id;
  final String emoji;
  final String label;

  const MemberDevotionalReactionOption({
    required this.id,
    required this.emoji,
    required this.label,
  });
}

class _ReactionTriggerButton extends StatelessWidget {
  final MemberDevotionalReactionOption? option;
  final bool isUpdating;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ReactionTriggerButton({
    required this.option,
    required this.isUpdating,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = option != null;
    final backgroundColor =
        isSelected ? const Color(0xFFF1E7FB) : Colors.white.withAlpha(232);
    final foregroundColor = isSelected ? AppColors.purple : AppColors.black;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: isUpdating ? null : onTap,
        onLongPress: isUpdating ? null : onLongPress,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 160),
          opacity: isUpdating ? 0.7 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (option != null)
                  Text(option!.emoji, style: const TextStyle(fontSize: 18))
                else
                  Icon(Icons.favorite_border_rounded, color: foregroundColor),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    option?.label ??
                        context.l10n.member_devotional_detail_reactions_cta,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: foregroundColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.keyboard_arrow_down_rounded, color: foregroundColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReactionPickerItem extends StatelessWidget {
  final MemberDevotionalReactionOption option;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReactionPickerItem({
    required this.option,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 92,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4EBFC) : const Color(0xFFF9F6FC),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.purple.withAlpha(90)
                    : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Text(option.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 8),
            Text(
              option.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Iterable<MemberDevotionalReactionOption> {
  MemberDevotionalReactionOption? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
}
