import 'dart:js_interop';

import 'package:web/web.dart' as web;

Future<String?> loadLocalFirebaseWebConfig() async {
  final response = await web.window.fetch('/.env'.toJS).toDart;
  if (!response.ok) {
    throw StateError('Unable to load Firebase web configuration.');
  }

  return (await response.text().toDart).toDart;
}
