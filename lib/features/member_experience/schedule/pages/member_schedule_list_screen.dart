import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/features/member_experience/home/store/member_upcoming_events_store.dart';
import 'package:church_finance_bk/features/member_experience/home/widgets/member_upcoming_events_section.dart';
import 'package:church_finance_bk/features/member_experience/widgets/member_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MemberScheduleListScreen extends StatelessWidget {
  const MemberScheduleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemberUpcomingEventsStore()..load(),
      child: Consumer<MemberUpcomingEventsStore>(
        builder: (context, store, child) {
          final l10n = context.l10n;

          return RefreshIndicator(
            onRefresh: store.load,
            child: ListView(
              children: [
                MemberHeaderWidget(
                  title: l10n.schedule_list_title,
                  onBack: () => context.pop(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        l10n.member_home_upcoming_events_title,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (store.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (store.events.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(l10n.member_home_upcoming_events_empty),
                        )
                      else
                        ...store.events.map(
                          (occurrence) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: MemberUpcomingEventCard(
                              occurrence: occurrence,
                              width: double.infinity,
                              onTap:
                                  () => context.push(
                                    '/member/schedule/detail',
                                    extra: occurrence,
                                  ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
