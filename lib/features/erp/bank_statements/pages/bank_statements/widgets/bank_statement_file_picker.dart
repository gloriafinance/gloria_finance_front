import 'dart:io';

import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class BankStatementFilePicker extends StatefulWidget {
  final void Function(MultipartFile? file) onFileSelected;

  const BankStatementFilePicker({super.key, required this.onFileSelected});

  @override
  State<BankStatementFilePicker> createState() =>
      _BankStatementFilePickerState();
}

class _BankStatementFilePickerState extends State<BankStatementFilePicker> {
  PlatformFile? _file;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyLight),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.file_upload_outlined, size: 36),
                const SizedBox(height: 12),
                Text(
                  _file != null
                      ? _file!.name
                      : 'Selecione ou arraste um arquivo .csv',
                  style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
                  textAlign: TextAlign.center,
                ),
                if (_file != null)
                  Text(
                    '${(_file!.size / 1024).toStringAsFixed(1)} KB',
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      color: AppColors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.redAccent)),
        ],
      ],
    );
  }

  Future<void> _pickFile() async {
    setState(() {
      _error = null;
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    var file = result.files.first;

    if (file.bytes == null && file.path != null) {
      final bytes = await File(file.path!).readAsBytes();
      file = PlatformFile(
        name: file.name,
        size: file.size,
        bytes: bytes,
        path: file.path,
        identifier: file.identifier,
      );
    }

    if (file.bytes == null) {
      setState(() {
        _error = 'Não foi possível ler o arquivo selecionado.';
      });
      widget.onFileSelected(null);
      return;
    }

    setState(() {
      _file = file;
    });

    widget.onFileSelected(
      MultipartFile.fromBytes(file.bytes!, filename: file.name),
    );
  }
}
