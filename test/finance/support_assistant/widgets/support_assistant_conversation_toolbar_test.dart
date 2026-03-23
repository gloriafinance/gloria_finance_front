import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_conversation_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_assistant_conversation_toolbar.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('starts, opens and deletes conversations from toolbar', (
    tester,
  ) async {
    var startedNewConversation = false;
    String? openedConversationId;
    String? deletedConversationId;

    await tester.pumpWidget(
      wrap(
        SupportAssistantConversationToolbar(
          isCompact: false,
          fillHeight: false,
          isLoading: false,
          selectedConversationId: 'conv-1',
          recentConversations: const [
            SupportConversationSummaryModel(
              conversationId: 'conv-1',
              title: 'Primeira conversa',
              createdAt: '2026-03-22T10:00:00.000Z',
              updatedAt: '2026-03-22T10:00:00.000Z',
            ),
            SupportConversationSummaryModel(
              conversationId: 'conv-2',
              title: 'Segunda conversa',
              createdAt: '2026-03-22T11:00:00.000Z',
              updatedAt: '2026-03-22T11:00:00.000Z',
            ),
          ],
          onStartNewConversation: () => startedNewConversation = true,
          onOpenConversation: (value) => openedConversationId = value,
          onDeleteConversation: (value) => deletedConversationId = value,
        ),
      ),
    );

    await tester.tap(find.text('Nova conversa'));
    await tester.pumpAndSettle();
    expect(startedNewConversation, isTrue);

    await tester.tap(find.text('Segunda conversa'));
    await tester.pumpAndSettle();
    expect(openedConversationId, 'conv-2');

    await tester.tap(
      find.byKey(const ValueKey('support-conversation-delete-conv-1')),
    );
    await tester.pumpAndSettle();
    expect(deletedConversationId, 'conv-1');
  });
}
