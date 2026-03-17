import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:gloria_finance/features/member_experience/devotional/utils/member_devotional_experience.dart';
import 'package:gloria_finance/features/member_experience/home/store/member_today_devotional_store.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MemberDevotionalMomentSection extends StatelessWidget {
  const MemberDevotionalMomentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Consumer<MemberTodayDevotionalStore>(
      builder: (context, store, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.member_home_devotional_moment_title,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontTitle,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.member_home_devotional_moment_subtitle,
                          style: TextStyle(
                            fontFamily: AppFonts.fontText,
                            fontSize: 13,
                            height: 1.45,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (store.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              if (store.devotional == null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCFAFE),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.purple.withAlpha(28)),
                  ),
                  child: Text(
                    l10n.member_home_devotional_moment_empty,
                    style: TextStyle(
                      fontFamily: AppFonts.fontText,
                      color: Colors.grey.shade700,
                    ),
                  ),
                )
              else
                _MemberDevotionalMomentCard(
                  devotional: store.devotional!,
                  onTap:
                      () => context.push(
                        '/member/devotional/${store.devotional!.devotionalId}',
                      ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MemberDevotionalMomentCard extends StatelessWidget {
  final MemberTodayDevotionalModel devotional;
  final VoidCallback onTap;

  const _MemberDevotionalMomentCard({
    required this.devotional,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final previewText = devotionalPreviewText(
      devotional.previewText.isNotEmpty
          ? devotional.previewText
          : l10n.member_home_devotional_moment_preview_fallback,
      maxLength: 92,
    );
    final timeLabel =
        devotional.scheduledAt == null
            ? '--:--'
            : DateFormat(
              'HH:mm',
              localeTag,
            ).format(devotional.scheduledAt!.toLocal());
    final reactionCount = devotional.reactionCount;
    final commentCount = devotional.commentCount;

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF8F1FF), Color(0xFFFFFCF7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.purple.withAlpha(26)),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withAlpha(20),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -22,
              child: Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE2D0F7).withAlpha(120),
                ),
              ),
            ),
            Positioned(
              left: -24,
              bottom: -34,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFE7C2).withAlpha(92),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(210),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.member_home_devotional_moment_today_badge,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                          fontSize: 12,
                          color: AppColors.purple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purple.withAlpha(55),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  devotional.title.isEmpty
                      ? l10n.devotional_item_no_title
                      : devotional.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 22,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  previewText,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 14,
                    height: 1.65,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          _MetricText(
                            icon: Icons.schedule_rounded,
                            label:
                                '${_dayLabel(context, devotional.dayOfWeek)} • $timeLabel',
                          ),
                          _MetricText(
                            icon: Icons.favorite_border_rounded,
                            label:
                                '$reactionCount ${l10n.member_home_devotional_moment_reactions}',
                          ),
                          _MetricText(
                            icon: Icons.mode_comment_outlined,
                            label:
                                '$commentCount ${l10n.member_home_devotional_moment_comments}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    constraints: const BoxConstraints(minWidth: 146),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.member_home_devotional_moment_read_now,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontSubTitle,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _dayLabel(BuildContext context, String day) {
    switch (day) {
      case 'MONDAY':
        return context.l10n.translate('schedule_day_monday');
      case 'TUESDAY':
        return context.l10n.translate('schedule_day_tuesday');
      case 'WEDNESDAY':
        return context.l10n.translate('schedule_day_wednesday');
      case 'THURSDAY':
        return context.l10n.translate('schedule_day_thursday');
      case 'FRIDAY':
        return context.l10n.translate('schedule_day_friday');
      case 'SATURDAY':
        return context.l10n.translate('schedule_day_saturday');
      case 'SUNDAY':
        return context.l10n.translate('schedule_day_sunday');
      default:
        return day;
    }
  }
}

class _MetricText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetricText({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade700),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 11.5,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
