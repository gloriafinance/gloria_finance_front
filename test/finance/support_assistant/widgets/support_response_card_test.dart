import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_response_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_response_card.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders report analysis without recommended screen and with subtle sources', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const SupportResponseCard(
          response: SupportAssistantResponseModel(
            conversationId: 'conv-1',
            answer: 'La iglesia cerró el mes con superávit.',
            intent: 'report_analysis',
            confidence: 'high',
            recommendedRoute: '',
            recommendedScreen: '',
            recommendedConcept: SupportRecommendedConceptModel(
              financialConceptId: '',
              name: '',
            ),
            steps: ['Revisar la tesorería principal', 'Verificar gastos altos'],
            warnings: ['Una cuenta terminó con saldo negativo'],
            extractedData: SupportExtractedDataModel(
              documentType: '',
              vendor: '',
              amount: '',
              currency: '',
              documentDate: '',
              summary: '',
            ),
            sources: ['report:income-statement', 'rule:financial-record-vs-payable'],
          ),
        ),
      ),
    );

    expect(find.text('Pantalla recomendada'), findsNothing);
    expect(find.text('Acciones sugeridas'), findsOneWidget);
    expect(find.text('Basado en'), findsOneWidget);
    expect(find.text('reporte emitido'), findsOneWidget);
    expect(find.text('reglas operativas'), findsOneWidget);
  });
}
