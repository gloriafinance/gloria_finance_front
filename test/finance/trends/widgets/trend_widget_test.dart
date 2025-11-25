import 'package:church_finance_bk/finance/trends/models/trend_model.dart';
import 'package:church_finance_bk/finance/trends/store/trend_store.dart';
import 'package:church_finance_bk/finance/trends/widgets/trend_widget.dart';
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

    // Set a large surface size to avoid overflow errors
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TrendStore>.value(
          value: fakeStore,
          child: const Scaffold(body: TrendWidget()),
        ),
      ),
    );

    // Reset surface size after test
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    expect(
      find.text('Composição de Receitas, Despesas e Resultado'),
      findsOneWidget,
    );
    expect(find.text('Comparativo: 11/2025 vs 10/2025'), findsOneWidget);
    expect(find.text('Receita Bruta'), findsOneWidget);
    expect(find.text('RECEITA'), findsOneWidget);
    expect(
      find.text('Despesas Operacionais'),
      findsNWidgets(2),
    ); // Main card and List
    expect(find.text('DESPESAS'), findsOneWidget);
    expect(find.text('Resultado do Período'), findsOneWidget);
    expect(find.text('RESULTADO'), findsOneWidget);

    expect(find.text('Receita'), findsNWidgets(2)); // Summary card and List
    expect(find.text('Operacionais'), findsOneWidget); // Summary Card
    expect(find.text('Repasses'), findsOneWidget); // Summary Card
    expect(find.text('Repasses Ministeriais'), findsOneWidget); // List
    expect(
      find.text('Investimentos'),
      findsNWidgets(2),
    ); // Summary Card and List
    expect(find.text('Resultado'), findsOneWidget); // Summary Card
    expect(find.text('Resultado Líquido'), findsOneWidget); // List
  });
}
