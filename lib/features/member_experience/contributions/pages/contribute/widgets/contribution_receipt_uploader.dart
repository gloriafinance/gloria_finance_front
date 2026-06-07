import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ContributionReceiptUploader extends StatefulWidget {
  final DateTime? paidAt;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<MultipartFile> onFileSelected;
  final VoidCallback? onFileRemoved;
  final String? fileName;

  const ContributionReceiptUploader({
    super.key,
    required this.paidAt,
    required this.onDateSelected,
    required this.onFileSelected,
    this.onFileRemoved,
    this.fileName,
  });

  @override
  State<ContributionReceiptUploader> createState() =>
      _ContributionReceiptUploaderState();
}

class _ContributionReceiptUploaderState
    extends State<ContributionReceiptUploader> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedBytes;
  String? _selectedName;

  @override
  void didUpdateWidget(covariant ContributionReceiptUploader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fileName == null && oldWidget.fileName != null) {
      _clearSelection(notifyParent: false);
    } else if (widget.fileName != null &&
        widget.fileName != oldWidget.fileName &&
        _selectedName != widget.fileName) {
      _selectedName = widget.fileName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat('dd/MM/yyyy', localeTag);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.member_contribution_receipt_label,
          style: const TextStyle(
            color: AppColors.purple,
            fontFamily: AppFonts.fontTitle,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        _buildImagePicker(context),
        if (_selectedBytes != null) ...[
          const SizedBox(height: 14),
          _buildPreviewCard(),
        ],
        const SizedBox(height: 16),
        Input(
          label: l10n.member_contribution_receipt_payment_date_label,
          initialValue:
              widget.paidAt != null ? dateFormat.format(widget.paidAt!) : '',
          onChanged: (_) {},
          onTap: () => _selectDate(context),
          onIconTap: () => _selectDate(context),
          readOnly: true,
          iconRight: const Icon(
            Icons.calendar_today_outlined,
            color: AppColors.greyMiddle,
          ),
          keyboardType: TextInputType.datetime,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    final borderColor = AppColors.purple.withValues(alpha: 0.7);

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      dashPattern: const [8, 4],
      color: borderColor,
      strokeWidth: 1.5,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _actionSelectImage,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.purple,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Selecionar foto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.fontTitle,
                    color: AppColors.purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Escolha a foto do comprovante na fototeca.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppFonts.fontText,
                    color: AppColors.purple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    final name = _selectedName ?? widget.fileName ?? 'receipt.jpg';
    final sizeLabel =
        _selectedBytes != null ? _formatFileSize(_selectedBytes!.length) : '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.memory(_selectedBytes!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: AppFonts.fontSubTitle,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: AppColors.blue,
                          size: 6,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          sizeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _clearSelection(notifyParent: true),
                icon: const Icon(Icons.close, color: AppColors.greyMiddle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _actionSelectImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 90,
      );

      if (picked == null) {
        return;
      }

      final bytes = await picked.readAsBytes();
      final fileName = picked.name.isNotEmpty ? picked.name : 'receipt.jpg';
      final multipartFile = MultipartFile.fromBytes(bytes, filename: fileName);

      setState(() {
        _selectedBytes = bytes;
        _selectedName = fileName;
      });

      widget.onFileSelected(multipartFile);
    } catch (_) {
      // Keep the UI quiet and let the user retry.
    }
  }

  void _clearSelection({required bool notifyParent}) {
    setState(() {
      _selectedBytes = null;
      _selectedName = null;
    });

    if (notifyParent && widget.onFileRemoved != null) {
      widget.onFileRemoved!();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await selectDate(context);

    if (picked != null) {
      widget.onDateSelected(picked);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 KB';
    const kb = 1024;
    const mb = kb * kb;

    if (bytes >= mb) {
      final sizeMb = bytes / mb;
      return '${sizeMb.toStringAsFixed(1)} MB';
    }

    final sizeKb = bytes / kb;
    return '${sizeKb.toStringAsFixed(1)} KB';
  }
}
