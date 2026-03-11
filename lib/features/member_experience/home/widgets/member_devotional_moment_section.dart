import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
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
                children: [
                  Expanded(
                    child: Text(
                      l10n.member_home_devotional_moment_title,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  if (store.isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (store.devotional == null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black.withAlpha(12)),
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
    final timeLabel =
        devotional.scheduledAt == null
            ? '--:--'
            : DateFormat(
              'HH:mm',
              localeTag,
            ).format(devotional.scheduledAt!.toLocal());

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withAlpha(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_book_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.member_home_devotional_moment_today_badge,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 12,
                      color: AppColors.purple,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    devotional.title.isEmpty
                        ? l10n.devotional_item_no_title
                        : devotional.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_dayLabel(context, devotional.dayOfWeek)} • $timeLabel',
                    style: TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.member_home_devotional_moment_cta,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontWeight: FontWeight.w600,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.purple),
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
