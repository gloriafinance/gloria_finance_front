import 'dart:io';

import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/patrimony_asset_form_store.dart';

class PatrimonyAttachmentsEditor extends StatelessWidget {
  const PatrimonyAttachmentsEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatrimonyAssetFormStore>(
      builder: (context, store, _) {
        final state = store.state;
        final attachments = state.existingAttachments;
        final newAttachments = state.newAttachments;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anexos (máximo 3)',
              style: const TextStyle(
                color: AppColors.purple,
                fontFamily: AppFonts.fontTitle,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            if (attachments.isEmpty && newAttachments.isEmpty)
              const Text(
                'Adicione comprovantes, fotos ou contratos relacionados ao bem.',
              ),
            ...attachments.map(
              (attachment) => _AttachmentTile(
                name: attachment.name,
                sizeLabel: attachment.formattedSize,
                onRemove: attachment.attachmentId != null
                    ? () => store.removeExistingAttachment(attachment.attachmentId!)
                    : null,
              ),
            ),
            ...List.generate(newAttachments.length, (index) {
              final file = newAttachments[index];
              return _AttachmentTile(
                name: file.filename ?? 'Arquivo',
                sizeLabel: _formatBytes(file.length),
                onRemove: () => store.removeNewAttachmentAt(index),
              );
            }),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Adicionar anexo',
              icon: Icons.attach_file,
              backgroundColor: AppColors.greyLight,
              textColor: Colors.black,
              onPressed: () async {
                final multipart = await _pickFile();
                if (multipart == null) {
                  return;
                }

                final added = store.addAttachment(multipart);
                if (!added) {
                  Toast.showMessage(
                    'Você atingiu o limite de 3 anexos por bem.',
                    ToastType.warning,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<MultipartFile?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    var file = result.files.first;

    if (file.bytes == null && file.path != null) {
      final bytes = File(file.path!).readAsBytesSync();
      file = PlatformFile(
        name: file.name,
        size: file.size,
        bytes: bytes,
        path: file.path,
        identifier: file.identifier,
      );
    }

    if (file.bytes == null) {
      return null;
    }

    return MultipartFile.fromBytes(file.bytes!, filename: file.name);
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 KB';
    const suffixes = ['B', 'KB', 'MB'];
    double size = bytes.toDouble();
    int index = 0;

    while (size >= 1024 && index < suffixes.length - 1) {
      size /= 1024;
      index++;
    }

    return '${size.toStringAsFixed(index == 0 ? 0 : 1)} ${suffixes[index]}';
  }
}

class _AttachmentTile extends StatelessWidget {
  final String name;
  final String sizeLabel;
  final VoidCallback? onRemove;

  const _AttachmentTile({
    required this.name,
    required this.sizeLabel,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: AppColors.purple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 14,
                  ),
                ),
                Text(
                  sizeLabel,
                  style: const TextStyle(color: AppColors.grey),
                ),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              tooltip: 'Remover',
              icon: const Icon(Icons.close, color: AppColors.purple),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
