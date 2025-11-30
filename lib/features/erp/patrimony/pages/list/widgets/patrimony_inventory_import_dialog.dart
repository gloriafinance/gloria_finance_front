import 'dart:io';

import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/features/erp/patrimony/models/patrimony_inventory_import_result.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/patrimony_assets_list_store.dart';

class PatrimonyInventoryImportDialog extends StatefulWidget {
  const PatrimonyInventoryImportDialog({super.key});

  @override
  State<PatrimonyInventoryImportDialog> createState() =>
      _PatrimonyInventoryImportDialogState();
}

class _PatrimonyInventoryImportDialogState
    extends State<PatrimonyInventoryImportDialog> {
  PlatformFile? _selectedFile;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PatrimonyAssetsListStore>();
    final isProcessing = store.importingInventory;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _descriptionSection(),
          const SizedBox(height: 16),
          Input(
            label: 'Arquivo CSV preenchido',
            initialValue: _selectedFile?.name ?? '',
            onChanged: (_) {},
            onTap: isProcessing ? null : () => _pickFile(),
            onIconTap: isProcessing ? null : () => _pickFile(),
            readOnly: true,
            iconRight: const Icon(
              Icons.upload_file_outlined,
              color: AppColors.greyMiddle,
            ),
          ),
          if (_selectedFile != null) ...[
            const SizedBox(height: 8),
            Text(
              'Tamanho: ${(_selectedFile!.size / 1024).ceil()} KB',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.greyMiddle,
                fontFamily: AppFonts.fontSubTitle,
              ),
            ),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ],
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.end,
            children: [
              AbsorbPointer(
                absorbing: isProcessing,
                child: ButtonActionTable(
                  color: AppColors.greyMiddle,
                  text: 'Cancelar',
                  icon: Icons.close,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              AbsorbPointer(
                absorbing: isProcessing,
                child: ButtonActionTable(
                  color: AppColors.purple,
                  text: isProcessing ? 'Importando...' : 'Importar checklist',
                  icon:
                      isProcessing
                          ? Icons.hourglass_top
                          : Icons.cloud_upload_outlined,
                  onPressed: () => _submit(store),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _descriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Envie o checklist físico preenchido para atualizar os bens.',
          style: TextStyle(fontFamily: AppFonts.fontSubTitle, fontSize: 14),
        ),
        SizedBox(height: 8),
        Text(
          'Certifique-se de manter as colunas "ID do ativo", "Código inventário" e '
          '"Quantidade inventário" preenchidas. Campos opcionais como status e '
          'observações também serão processados, quando informados.',
          style: TextStyle(fontSize: 13, fontFamily: AppFonts.fontSubTitle),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['csv'],
      withData: true,
    );

    if (!mounted || result == null || result.files.isEmpty) {
      return;
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

    setState(() {
      _selectedFile = file;
      _errorMessage = null;
    });
  }

  Future<void> _submit(PatrimonyAssetsListStore store) async {
    if (_selectedFile == null) {
      setState(() {
        _errorMessage = 'Selecione o arquivo exportado antes de importar.';
      });
      return;
    }

    final file = _selectedFile!;
    final bytes =
        file.bytes ??
        (file.path != null ? File(file.path!).readAsBytesSync() : null);

    if (bytes == null) {
      setState(() {
        _errorMessage = 'Não foi possível ler o arquivo selecionado.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final multipart = MultipartFile.fromBytes(bytes, filename: file.name);

    final PatrimonyInventoryImportResult? result = await store
        .importInventoryChecklist(multipart);

    if (!mounted) {
      return;
    }

    if (result != null) {
      Navigator.of(context).pop(result);
    } else {
      setState(() {
        _errorMessage =
            'Não foi possível importar o checklist. Tente novamente.';
      });
    }
  }
}
