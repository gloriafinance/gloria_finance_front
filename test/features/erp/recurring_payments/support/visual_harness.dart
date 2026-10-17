import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Utilidades compartidas por las capturas de los dos entregables de
/// Pagamentos Recorrentes: cargan las fuentes reales y escriben los PNG.

/// Escribe la captura del boundary marcado con la clave de captura.
Future<void> captureIfNeeded(
  WidgetTester tester,
  bool generate,
  String path,
) async {
  if (!generate) return;

  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('recurring-payments-capture')),
  );

  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File(path)..createSync(recursive: true);
    file.writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

Future<void> loadAppFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(Uint8List.fromList(bytes).buffer)));
  await loader.load();
}

Future<void> loadAppFonts() async {
  final fonts = {
    'fontTitle': 'fonts/Poppins-SemiBold.ttf',
    'fontSubTitle': 'fonts/Poppins-Regular.ttf',
    'fontText': 'fonts/Poppins-Light.ttf',
  };

  for (final entry in fonts.entries) {
    await loadAppFont(entry.key, entry.value);
  }

  // Los textos sin `fontFamily` (por ejemplo el botón de ayuda contextual) usan
  // la fuente por defecto de la plataforma; en test eso se dibuja como cajas.
  // Se sustituye por Poppins para que la captura sea legible.
  await loadAppFont('Roboto', 'fonts/Poppins-Regular.ttf');

  // Iconos: sin esto el motor de test dibuja cuadros vacíos.
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    final icons =
        '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf';
    if (File(icons).existsSync()) {
      await loadAppFont('MaterialIcons', icons);
    }
  }
}
