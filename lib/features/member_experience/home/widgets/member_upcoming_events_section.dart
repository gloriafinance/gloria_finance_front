import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:gloria_finance/features/member_experience/home/store/member_upcoming_events_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MemberUpcomingEventsSection extends StatelessWidget {
  final bool showSeeAll;

  const MemberUpcomingEventsSection({super.key, this.showSeeAll = true});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Consumer<MemberUpcomingEventsStore>(
      builder: (context, store, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.member_home_upcoming_events_title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  if (showSeeAll)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.purple,
                      ),
                      onPressed: () => context.push('/member/schedule'),
                      child: Text(
                        l10n.common_see_all,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (store.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (store.events.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.member_home_upcoming_events_empty,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            else
              SizedBox(
                height: 88,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  scrollDirection: Axis.horizontal,
                  itemCount: store.events.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return MemberUpcomingEventCard(
                      occurrence: store.events[index],
                      onTap:
                          () => context.push(
                            '/member/schedule/detail',
                            extra: store.events[index],
                          ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class MemberUpcomingEventCard extends StatelessWidget {
  final WeeklyOccurrence occurrence;
  final VoidCallback? onTap;
  final double width;

  const MemberUpcomingEventCard({
    super.key,
    required this.occurrence,
    this.onTap,
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(occurrence.date);
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final month =
        date == null
            ? ''
            : DateFormat(
              'MMM',
              localeTag,
            ).format(date).replaceAll('.', '').toUpperCase();

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date?.day.toString().padLeft(2, '0') ?? '--',
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    month,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.0,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    occurrence.title,
                    maxLines: 1,
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
                    '${occurrence.startTime} – ${occurrence.endTime}',
                    style: TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 13,
                      color: AppColors.black.withAlpha(200),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    occurrence.location.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
