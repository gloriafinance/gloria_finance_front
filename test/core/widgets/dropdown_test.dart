import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(width: 320, child: child),
        ),
      ),
    );
  }

  group('Dropdown', () {
    testWidgets(
      'actualiza initialValue desde el padre sin marcar el Form durante el build',
      (tester) async {
        final formKey = GlobalKey<FormState>();
        var value = 'a';
        late StateSetter setOuterState;

        await tester.pumpWidget(
          wrap(
            Form(
              key: formKey,
              child: StatefulBuilder(
                builder: (context, setState) {
                  setOuterState = setState;
                  return Dropdown(
                    label: 'Conceito',
                    items: const ['a', 'b'],
                    initialValue: value,
                    onValidator: (
                      current,
                    ) => current == 'b' ? null : 'valor obrigatório',
                    onChanged: (selected) =>
                        setState(() => value = selected),
                  );
                },
              ),
            ),
          ),
        );

        // El padre cambia el valor (como cuando el store notifica y reconstruye
        // la sección): el FormField debe sincronizarse sin tocar el Form
        // mientras el framework está construyendo.
        setOuterState(() => value = 'b');
        await tester.pump();

        expect(tester.takeException(), isNull);

        // El `didChange` diferido corre al final del frame y deja el FormField
        // con el valor vigente: la validación del Form debe pasar.
        await tester.pump();
        expect(formKey.currentState!.validate(), isTrue);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('los ListTile se pintan sobre la superficie del Material', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          Dropdown(
            label: 'Conceito',
            items: const ['a', 'b'],
            initialValue: 'a',
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(CompositedTransformTarget).first);
      await tester.pumpAndSettle();

      final listTileElement = tester.element(find.byType(ListTile).first);

      Material? surface;
      var hasOpaqueDecorationBetween = false;

      listTileElement.visitAncestorElements((element) {
        final widget = element.widget;
        if (widget is DecoratedBox) {
          final decoration = widget.decoration;
          if (decoration is BoxDecoration &&
              (decoration.color?.a ?? 0) > 0) {
            hasOpaqueDecorationBetween = true;
          }
        }
        if (widget is Material) {
          surface = widget;
          return false;
        }
        return true;
      });

      expect(surface, isNotNull);
      expect(surface!.color, Colors.white);
      expect(hasOpaqueDecorationBetween, isFalse);
    });
  });
}
