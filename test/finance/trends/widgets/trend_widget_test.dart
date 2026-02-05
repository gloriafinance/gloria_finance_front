import 'package:gloria_finance/features/erp/trends/models/trend_model.dart';
import 'package:gloria_finance/features/erp/trends/store/trend_store.dart';
import 'package:gloria_finance/features/erp/trends/widgets/trend_widget.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class FakeTrendStore extends ChangeNotifier implements TrendStore {
  @override
  bool get isLoading => false;

  @override
  String? get error => null;

  @override
  TrendResponse? get trendResponse => TrendResponse(
    period: TrendPeriod(year: 2025, month: 11),
    trend: TrendData(
      revenue: TrendValue(current: 1000, previous: 900),
      opex: TrendValue(current: 500, previous: 400),
      transfers: TrendValue(current: 100, previous: 50),
      capex: TrendValue(current: 200, previous: 100),
      netIncome: TrendValue(current: 200, previous: 350),
    ),
  );

  @override
  Future<void> fetchTrends() async {}
}

void main() {
  testWidgets('TrendWidget displays data correctly', (
    WidgetTester tester,
  ) async {
    final fakeStore = FakeTrendStore();
    final l10n = await AppLocalizations.delegate.load(const Locale('pt', 'BR'));

    // Set a large surface size to avoid overflow errors
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ChangeNotifierProvider<TrendStore>.value(
          value: fakeStore,
          child: const Scaffold(body: TrendWidget()),
        ),
      ),
    );

    // Reset surface size after test
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    expect(find.text(l10n.trends_header_title), findsOneWidget);
    expect(
      find.text(l10n.trends_header_comparison('11/2025', '10/2025')),
      findsOneWidget,
    );
    expect(find.text('Receita Bruta'), findsOneWidget);
    expect(find.text('RECEITA'), findsOneWidget);
    expect(find.text('Despesas Operacionais'), findsOneWidget);
    expect(find.text('Operacionais'), findsOneWidget);
    expect(find.text('DESPESAS'), findsOneWidget);
    expect(find.text('Resultado do Período'), findsOneWidget);
    expect(find.text('RESULTADO'), findsOneWidget);

    expect(find.text(l10n.trends_summary_revenue), findsNWidgets(2));
    expect(find.text(l10n.trends_summary_opex), findsOneWidget);
    expect(find.text(l10n.trends_summary_transfers), findsOneWidget);
    expect(find.text(l10n.trends_list_transfers), findsOneWidget);
    expect(find.text(l10n.trends_summary_capex), findsNWidgets(2));
    expect(find.text(l10n.trends_summary_net_income), findsOneWidget);
    expect(find.text(l10n.trends_list_net_income), findsOneWidget);
  });
}
