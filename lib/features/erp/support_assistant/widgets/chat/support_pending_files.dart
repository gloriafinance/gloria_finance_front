import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SupportPendingFiles extends StatelessWidget {
  const SupportPendingFiles({
    super.key,
    required this.files,
    required this.onRemoveFile,
  });

  final List<PlatformFile> files;
  final ValueChanged<PlatformFile> onRemoveFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: files
            .map(
              (file) => Chip(
                label: Text(file.name),
                onDeleted: () => onRemoveFile(file),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
