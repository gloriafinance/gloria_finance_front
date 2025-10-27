import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/patrimony_asset_enums.dart';
import '../store/patrimony_asset_detail_store.dart';

class PatrimonyAssetDisposalDialog extends StatefulWidget {
  const PatrimonyAssetDisposalDialog({super.key});

  @override
  State<PatrimonyAssetDisposalDialog> createState() =>
      _PatrimonyAssetDisposalDialogState();
}

class _PatrimonyAssetDisposalDialogState
    extends State<PatrimonyAssetDisposalDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _statusLabel;
  String? _dateValue;

  @override
  void dispose() {
    _reasonController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailStore = context.watch<PatrimonyAssetDetailStore>();

    return AlertDialog(
      title: const Text('Registrar baixa'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _statusField(),
              const SizedBox(height: 16),
              _reasonField(),
              const SizedBox(height: 16),
              _dateField(context),
              const SizedBox(height: 16),
              _notesField(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed:
              detailStore.registeringDisposal ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: detailStore.registeringDisposal ? null : () => _submit(detailStore),
          child: detailStore.registeringDisposal
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirmar'),
        ),
      ],
    );
  }

  Widget _statusField() {
    final options = PatrimonyAssetStatusCollection.disposalLabels();

    return DropdownButtonFormField<String>(
      decoration: _inputDecoration('Status'),
      items: options
          .map((label) => DropdownMenuItem<String>(
                value: label,
                child: Text(label),
              ))
          .toList(),
      value: _statusLabel,
      onChanged: (value) => setState(() => _statusLabel = value),
      validator: (value) => value == null || value.isEmpty ? 'Selecione um status' : null,
    );
  }

  Widget _reasonField() {
    return TextFormField(
      controller: _reasonController,
      decoration: _inputDecoration('Motivo'),
      validator: (value) => value == null || value.trim().isEmpty ? 'Informe o motivo da baixa' : null,
      maxLines: 2,
    );
  }

  Widget _dateField(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: _inputDecoration('Data da baixa (opcional)').copyWith(
        suffixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      onTap: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1970),
          lastDate: DateTime(2100),
        );

        if (selected != null) {
          final display = DateFormat('dd/MM/yyyy').format(selected);
          setState(() {
            _dateController.text = display;
            _dateValue = DateFormat('yyyy-MM-dd').format(selected);
          });
        }
      },
    );
  }

  Widget _notesField() {
    return TextFormField(
      controller: _notesController,
      decoration: _inputDecoration('Observações (opcional)'),
      maxLines: 3,
    );
  }

  Future<void> _submit(PatrimonyAssetDetailStore detailStore) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final status =
        PatrimonyAssetStatusCollection.disposalApiValueFromLabel(_statusLabel);

    if (status == null) {
      return;
    }

    final success = await detailStore.registerDisposal(
      status: status,
      reason: _reasonController.text.trim(),
      disposedAt: _dateValue,
      observations:
          _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
