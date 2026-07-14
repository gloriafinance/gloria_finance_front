import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/features/erp/settings/members/widgets/member_delete_confirmation_dialog.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('requires confirmation before returning true', (tester) async {
    bool? result;

    await tester.pumpWidget(
      wrap(
        Builder(
          builder:
              (context) => ElevatedButton(
                onPressed: () async {
                  result = await showMemberDeleteConfirmationDialog(
                    context,
                    memberName: 'Ana Silva',
                  );
                },
                child: const Text('open'),
              ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Excluir membro?'), findsOneWidget);
    expect(find.textContaining('Ana Silva'), findsOneWidget);

    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });
}
