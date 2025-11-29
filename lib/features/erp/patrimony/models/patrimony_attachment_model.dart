import 'package:intl/intl.dart';

class PatrimonyAttachmentModel {
  final String? attachmentId;
  final String name;
  final String url;
  final String mimetype;
  final int size;
  final DateTime? uploadedAt;

  PatrimonyAttachmentModel({
    this.attachmentId,
    required this.name,
    required this.url,
    required this.mimetype,
    required this.size,
    this.uploadedAt,
  });

  factory PatrimonyAttachmentModel.fromMap(Map<String, dynamic> map) {
    return PatrimonyAttachmentModel(
      attachmentId: map['attachmentId'] as String?,
      name: map['name'] as String? ?? '',
      url: map['url'] as String? ?? '',
      mimetype: map['mimetype'] as String? ?? 'application/octet-stream',
      size: map['size'] is int
          ? map['size'] as int
          : int.tryParse('${map['size']}') ?? 0,
      uploadedAt: map['uploadedAt'] != null
          ? DateTime.tryParse(map['uploadedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (attachmentId != null) 'attachmentId': attachmentId,
      'name': name,
      'url': url,
      'mimetype': mimetype,
      'size': size,
      if (uploadedAt != null) 'uploadedAt': uploadedAt!.toIso8601String(),
    };
  }

  String get formattedSize {
    if (size <= 0) {
      return '0 KB';
    }

    const suffixes = ['B', 'KB', 'MB', 'GB'];
    double value = size.toDouble();
    int index = 0;

    while (value >= 1024 && index < suffixes.length - 1) {
      value /= 1024;
      index++;
    }

    return '${value.toStringAsFixed(index == 0 ? 0 : 1)} ${suffixes[index]}';
  }

  String get uploadedAtLabel {
    if (uploadedAt == null) {
      return '';
    }

    return DateFormat('dd/MM/yyyy HH:mm').format(uploadedAt!);
  }
}
