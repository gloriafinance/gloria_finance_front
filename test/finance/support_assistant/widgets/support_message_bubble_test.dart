import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_assistant_response_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_chat_attachment_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_chat_message_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_message_bubble.dart';
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

  testWidgets('renders reopened image attachments from conversation history', (
    tester,
  ) async {
    final pngBytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO2Z8WQAAAAASUVORK5CYII=',
    );

    await tester.pumpWidget(
      wrap(
        SupportMessageBubble(
          message: SupportChatMessageModel(
            role: SupportChatRole.user,
            text: 'Analiza este comprobante',
            attachments: [
              SupportChatAttachmentModel(
                name: 'comprobante.png',
                mimeType: 'image/png',
                size: pngBytes.length,
                bytes: pngBytes,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Analiza este comprobante'), findsOneWidget);
    expect(find.text('comprobante.png'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('allows expanding long assistant messages', (tester) async {
    final longText = List.filled(20, 'Este es un análisis detallado del reporte.')
        .join(' ');

    await tester.pumpWidget(
      wrap(
        SupportMessageBubble(
          message: SupportChatMessageModel(
            role: SupportChatRole.assistant,
            text: longText,
            response: const SupportAssistantResponseModel(
              conversationId: 'conv-1',
              answer: 'Respuesta',
              intent: 'general_support',
              confidence: 'high',
              recommendedRoute: '',
              recommendedScreen: '',
              recommendedConcept: SupportRecommendedConceptModel(
                financialConceptId: '',
                name: '',
              ),
              steps: [],
              warnings: [],
              extractedData: SupportExtractedDataModel(
                documentType: '',
                vendor: '',
                amount: '',
                currency: '',
                documentDate: '',
                summary: '',
              ),
              sources: [],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Ver más'), findsOneWidget);

    await tester.tap(find.text('Ver más'));
    await tester.pumpAndSettle();

    expect(find.text('Ver menos'), findsOneWidget);
  });
}
