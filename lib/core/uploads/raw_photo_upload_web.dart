import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web/web.dart' as web;

Future<Map<String, dynamic>> uploadRawPhotoOnWeb({
  required XFile photo,
  required Uri url,
  required String method,
  required String mimeType,
  Map<String, String> headers = const {},
}) async {
  final fileResponse = await web.window.fetch(photo.path.toJS).toDart;
  final file = await fileResponse.blob().toDart;
  final request = web.XMLHttpRequest();
  final completion = Completer<Map<String, dynamic>>();

  request.open(method, url.toString());
  request.setRequestHeader('Content-Type', mimeType);
  for (final entry in headers.entries) {
    request.setRequestHeader(entry.key, entry.value);
  }
  request.onLoad.first.then((_) {
    final payload = request.responseText;
    if (request.status >= 200 && request.status < 300) {
      completion.complete(
        Map<String, dynamic>.from(_decodePayload(payload) as Map),
      );
      return;
    }
    completion.completeError(
      DioException(
        requestOptions: RequestOptions(path: url.toString(), method: method),
        response: Response(
          requestOptions: RequestOptions(path: url.toString(), method: method),
          statusCode: request.status,
          data: _decodePayload(payload),
        ),
        type: DioExceptionType.badResponse,
      ),
    );
  });
  request.onError.first.then((_) {
    completion.completeError(
      DioException(
        requestOptions: RequestOptions(path: url.toString(), method: method),
        type: DioExceptionType.connectionError,
      ),
    );
  });
  request.send(file);

  return completion.future;
}

dynamic _decodePayload(String payload) {
  if (payload.isEmpty) return null;

  try {
    return jsonDecode(payload);
  } on FormatException {
    return payload;
  }
}
