import 'package:image_picker/image_picker.dart';

Future<Map<String, dynamic>> uploadRawPhotoOnWeb({
  required XFile photo,
  required Uri url,
  required String method,
  required String mimeType,
  Map<String, String> headers = const {},
}) => throw UnsupportedError('Browser-only photo upload.');
