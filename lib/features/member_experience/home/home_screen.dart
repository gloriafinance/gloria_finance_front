import 'package:church_finance_bk/features/member_experience/home/store/member_upcoming_events_store.dart';
import 'package:church_finance_bk/features/member_experience/home/widgets/member_upcoming_events_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MemberUpcomingEventsStore _eventsStore;

  @override
  void initState() {
    super.initState();
    _eventsStore = MemberUpcomingEventsStore()..load();
  }

  @override
  void dispose() {
    _eventsStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _eventsStore,
      child: RefreshIndicator(
        onRefresh: _eventsStore.load,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [MemberUpcomingEventsSection(), const SizedBox(height: 16)],
        ),
      ),
    );
  }
}
