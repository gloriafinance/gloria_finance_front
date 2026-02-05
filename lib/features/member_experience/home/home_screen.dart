import 'package:gloria_finance/features/member_experience/home/store/member_generosity_summary_store.dart';
import 'package:gloria_finance/features/member_experience/home/store/member_upcoming_events_store.dart';
import 'package:gloria_finance/features/member_experience/home/widgets/member_generosity_summary_section.dart';
import 'package:gloria_finance/features/member_experience/home/widgets/member_upcoming_events_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MemberUpcomingEventsStore _eventsStore;
  late final MemberGenerositySummaryStore _summaryStore;

  @override
  void initState() {
    super.initState();
    _eventsStore = MemberUpcomingEventsStore()..load();
    _summaryStore = MemberGenerositySummaryStore()..load();
  }

  @override
  void dispose() {
    _eventsStore.dispose();
    _summaryStore.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    await Future.wait([_eventsStore.load(), _summaryStore.load()]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _eventsStore),
        ChangeNotifierProvider.value(value: _summaryStore),
      ],
      child: RefreshIndicator(
        onRefresh: _refreshAll,
        child: ListView(
          children: const [
            MemberGenerositySummarySection(),
            SizedBox(height: 16),
            MemberUpcomingEventsSection(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
