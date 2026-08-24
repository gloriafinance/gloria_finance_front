import 'raw_photo_upload_stub.dart'
    if (dart.library.html) 'raw_photo_upload_web.dart'
    as implementation;

import 'package:image_picker/image_picker.dart';

Future<Map<String, dynamic>> uploadRawPhotoOnWeb({
  required XFile photo,
  required Uri url,
  required String method,
  required String mimeType,
  Map<String, String> headers = const {},
}) => implementation.uploadRawPhotoOnWeb(
  photo: photo,
  url: url,
  method: method,
  mimeType: mimeType,
  headers: headers,
);
