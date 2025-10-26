import 'dart:io';
import 'dart:typed_data';

import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../store/patrimony_asset_form_store.dart';
import '../state/patrimony_asset_form_state.dart';

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
              (attachment) {
                final isImage = attachment.mimetype.toLowerCase().startsWith('image/');
                final isPdf = attachment.mimetype.toLowerCase().contains('pdf');
                return _AttachmentTile(
                  name: attachment.name,
                  sizeLabel: attachment.formattedSize,
                  preview: isImage
                      ? _AttachmentPreview.network(attachment.url)
                      : null,
                  onView: () => _openExistingAttachment(attachment.url),
                  viewLabel: isPdf ? 'Ver PDF' : 'Abrir',
                  onRemove: attachment.attachmentId != null
                      ? () => store.removeExistingAttachment(attachment.attachmentId!)
                      : null,
                  onPreviewTap: isImage
                      ? () => _showImageDialog(context, Image.network(attachment.url, fit: BoxFit.contain))
                      : null,
                );
              },
            ),
            ...List.generate(newAttachments.length, (index) {
              final attachment = newAttachments[index];
              return _AttachmentTile(
                name: attachment.name,
                sizeLabel: attachment.formattedSize,
                preview: attachment.isImage && attachment.bytes != null
                    ? _AttachmentPreview.memory(attachment.bytes!)
                    : null,
                onView: attachment.isPdf && attachment.bytes != null
                    ? () => _openPdfBytes(attachment.bytes!)
                    : (attachment.isImage && attachment.bytes != null
                        ? () => _showImageDialog(
                              context,
                              Image.memory(attachment.bytes!, fit: BoxFit.contain),
                            )
                        : null),
                viewLabel: attachment.isPdf ? 'Ver PDF' : 'Visualizar',
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
                final newAttachment = await _pickFile();
                if (newAttachment == null) {
                  return;
                }

                final added = store.addAttachment(newAttachment);
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

  Future<PatrimonyNewAttachment?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    var file = result.files.first;
    Uint8List? bytes = file.bytes;

    if (bytes == null && file.path != null) {
      bytes = File(file.path!).readAsBytesSync();
      file = PlatformFile(
        name: file.name,
        size: file.size,
        bytes: bytes,
        path: file.path,
        identifier: file.identifier,
      );
    }

    if (bytes == null) {
      return null;
    }

    final mime = _inferMimeType(file.extension ?? '');
    final multipart = MultipartFile.fromBytes(
      bytes,
      filename: file.name,
    );

    return PatrimonyNewAttachment(
      file: multipart,
      name: file.name,
      size: file.size,
      bytes: bytes,
      mimeType: mime,
    );
  }

  String? _inferMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'pdf':
        return 'application/pdf';
      default:
        return null;
    }
  }

  static Future<void> _openExistingAttachment(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _openPdfBytes(Uint8List bytes) async {
    final dataUrl = Uri.dataFromBytes(
      bytes,
      mimeType: 'application/pdf',
    );
    await launchUrl(dataUrl);
  }

  static Future<void> _showImageDialog(BuildContext context, Widget image) async {
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 480,
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image,
            ),
          ),
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final String name;
  final String sizeLabel;
  final Widget? preview;
  final VoidCallback? onPreviewTap;
  final VoidCallback? onView;
  final String? viewLabel;
  final VoidCallback? onRemove;

  const _AttachmentTile({
    required this.name,
    required this.sizeLabel,
    this.preview,
    this.onPreviewTap,
    this.onView,
    this.viewLabel,
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
          if (preview != null)
            GestureDetector(
              onTap: onPreviewTap ?? onView,
              child: preview!,
            )
          else
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
          if (onView != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CustomButton(
                text: viewLabel ?? 'Ver',
                backgroundColor: AppColors.blue,
                textColor: Colors.white,
                onPressed: onView!,
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

class _AttachmentPreview extends StatelessWidget {
  final Widget child;

  const _AttachmentPreview._(this.child);

  factory _AttachmentPreview.network(String url) {
    return _AttachmentPreview._(
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.broken_image,
            color: AppColors.grey,
            size: 48,
          ),
        ),
      ),
    );
  }

  factory _AttachmentPreview.memory(Uint8List bytes) {
    return _AttachmentPreview._(
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          bytes,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.broken_image,
            color: AppColors.grey,
            size: 48,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
