import 'package:church_finance_bk/finance/providers/contributions_provider.dart';
import 'package:church_finance_bk/finance/ui/widgets/contribution_table.dart';
import 'package:church_finance_bk/layout_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContributionsScreen extends ConsumerStatefulWidget {
  const ContributionsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContributionsScreenState();
}

class _ContributionsScreenState extends ConsumerState<ContributionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(contributionServiceProvider.notifier)
          .searchContributions(ref.watch(contributionsFilterProvider));
    });
  }

  @override
  Widget build(BuildContext context) {
    //final contributionFilters = ref.watch(contributionsFilterProvider);
    //final service = ref.watch(contributionServiceProvider);

    //final contributions = service.;

    return LayoutDashboard(
      'Lista de contribuições',
      screen: ContributionTable(),
    );
  }
}
