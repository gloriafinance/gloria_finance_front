import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class SupportChatAttachmentModel {
  const SupportChatAttachmentModel({
    required this.name,
    required this.mimeType,
    required this.size,
    this.bytes,
  });

  factory SupportChatAttachmentModel.fromPlatformFile(PlatformFile file) {
    final bytes = file.bytes;

    return SupportChatAttachmentModel(
      name: file.name,
      mimeType: file.extension != null
          ? _inferMimeType(file.extension!)
          : 'application/octet-stream',
      size: bytes?.length ?? file.size,
      bytes: bytes,
    );
  }

  factory SupportChatAttachmentModel.fromConversationJson(
    Map<String, dynamic> json,
  ) {
    final rawBase64 = json['dataBase64']?.toString() ?? '';
    Uint8List? bytes;

    if (rawBase64.isNotEmpty) {
      try {
        bytes = base64Decode(rawBase64);
      } catch (_) {
        bytes = null;
      }
    }

    return SupportChatAttachmentModel(
      name: json['name']?.toString() ?? '',
      mimeType: json['mimeType']?.toString() ?? 'application/octet-stream',
      size: int.tryParse(json['size']?.toString() ?? '') ?? bytes?.length ?? 0,
      bytes: bytes,
    );
  }

  final String name;
  final String mimeType;
  final int size;
  final Uint8List? bytes;

  bool get isImage => mimeType.startsWith('image/');

  static String _inferMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}
