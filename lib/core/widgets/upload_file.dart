import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import '../theme/app_fonts.dart';

class UploadFile extends StatefulWidget {
  final String label;
  final void Function(MultipartFile) multipartFile;

  const UploadFile({
    super.key,
    required this.label,
    required this.multipartFile,
  });

  @override
  State<StatefulWidget> createState() => _UploadFile();
}

class _UploadFile extends State<UploadFile> {
  PlatformFile? _platformFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(),
        const SizedBox(height: 12),
        _selectorFile(),
        if (_platformFile != null) _presentationInformationFile(),
      ],
    );
  }

  Widget _presentationInformationFile() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.insert_drive_file_outlined,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _platformFile!.name,
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
                          _formatFileSize(_platformFile!.size),
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
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: 1,
                backgroundColor: AppColors.greyLight,
                color: AppColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectorFile() {
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
          onTap: _actionSelectFile,
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
                  child: Image.asset(
                    'images/upload-cloud.png',
                    width: 40,
                    height: 40,
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                Text(
                  'JPG, PNG ou PDF, com no máximo 10MB',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: AppFonts.fontText,
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: _actionSelectFile,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.purple,
                    side: const BorderSide(color: AppColors.purple, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    'SELECIONAR ARQUIVO',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppFonts.fontSubTitle,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        widget.label,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: AppColors.purple,
          fontFamily: AppFonts.fontTitle,
          fontSize: 16,
        ),
      ),
    );
  }

  _actionSelectFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (file != null) {
      setState(() {
        _platformFile = file.files.first;

        if (_platformFile!.bytes == null && _platformFile!.path != null) {
          final fileBytes = File(_platformFile!.path!).readAsBytesSync();
          _platformFile = PlatformFile(
            name: _platformFile!.name,
            size: _platformFile!.size,
            bytes: fileBytes,
            path: _platformFile!.path,
            identifier: _platformFile!.identifier,
          );
        }

        // Crear MultipartFile desde los bytes del archivo (sin usar path)
        if (_platformFile!.bytes != null) {
          widget.multipartFile(
            MultipartFile.fromBytes(
              _platformFile!.bytes!,
              filename: _platformFile!.name,
            ),
          );
        }
      });
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
