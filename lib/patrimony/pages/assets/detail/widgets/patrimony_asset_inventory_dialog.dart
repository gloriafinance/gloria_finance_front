import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/patrimony_asset_enums.dart';
import '../store/patrimony_asset_detail_store.dart';

class PatrimonyAssetInventoryDialog extends StatefulWidget {
  const PatrimonyAssetInventoryDialog({super.key});

  @override
  State<PatrimonyAssetInventoryDialog> createState() =>
      _PatrimonyAssetInventoryDialogState();
}

class _PatrimonyAssetInventoryDialogState
    extends State<PatrimonyAssetInventoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _statusLabel = PatrimonyInventoryStatus.confirmed.label;
  String? _dateValue;

  @override
  void dispose() {
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailStore = context.watch<PatrimonyAssetDetailStore>();

    return AlertDialog(
      title: const Text('Registrar inventário físico'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _statusField(),
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
              detailStore.registeringInventory ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed:
              detailStore.registeringInventory ? null : () => _submit(detailStore),
          child: detailStore.registeringInventory
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
    final options = PatrimonyInventoryStatusCollection.labels();

    return DropdownButtonFormField<String>(
      decoration: _inputDecoration('Resultado do inventário'),
      items: options
          .map((label) => DropdownMenuItem<String>(
                value: label,
                child: Text(label),
              ))
          .toList(),
      value: _statusLabel,
      onChanged: (value) => setState(() => _statusLabel = value),
      validator: (value) => value == null || value.isEmpty ? 'Selecione o resultado' : null,
    );
  }

  Widget _dateField(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: _inputDecoration('Data da conferência (opcional)').copyWith(
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
      decoration: _inputDecoration('Notas (opcional)'),
      maxLines: 3,
    );
  }

  Future<void> _submit(PatrimonyAssetDetailStore detailStore) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final status =
        PatrimonyInventoryStatusCollection.apiValueFromLabel(_statusLabel);

    if (status == null) {
      return;
    }

    final success = await detailStore.registerInventory(
      status: status,
      checkedAt: _dateValue,
      notes:
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
