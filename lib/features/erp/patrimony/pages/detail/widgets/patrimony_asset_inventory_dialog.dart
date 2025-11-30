import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/patrimony_asset_enums.dart';
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

  String? _statusLabel = PatrimonyInventoryStatus.confirmed.label;
  String _checkedAtDisplay = '';
  String _notes = '';
  String _code = '';
  String _quantityText = '';
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }

    final detailStore = context.read<PatrimonyAssetDetailStore>();
    final asset = detailStore.asset;
    _code = asset.code;
    _quantityText = asset.quantity > 0 ? '${asset.quantity}' : '';
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final detailStore = context.watch<PatrimonyAssetDetailStore>();

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
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _codeField(detailStore),
                const SizedBox(height: 16),
                _quantityField(detailStore),
                const SizedBox(height: 16),
                _statusField(),
                const SizedBox(height: 16),
                _dateField(context),
                const SizedBox(height: 16),
                _notesField(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.end,
              children: [
                AbsorbPointer(
                  absorbing: detailStore.registeringInventory,
                  child: ButtonActionTable(
                    color: AppColors.greyMiddle,
                    text: 'Cancelar',
                    icon: Icons.close,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                AbsorbPointer(
                  absorbing: detailStore.registeringInventory,
                  child: ButtonActionTable(
                    color: AppColors.purple,
                    text:
                        detailStore.registeringInventory
                            ? 'Registrando...'
                            : 'Confirmar',
                    icon:
                        detailStore.registeringInventory
                            ? Icons.hourglass_top
                            : Icons.check_circle_outline,
                    onPressed: () => _submit(detailStore),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusField() {
    final options = PatrimonyInventoryStatusCollection.labels();

    return Dropdown(
      label: 'Resultado do inventário',
      items: options,
      initialValue: _statusLabel,
      onChanged: (value) => setState(() => _statusLabel = value),
      onValidator:
          (value) =>
              value == null || value.isEmpty ? 'Selecione o resultado' : null,
    );
  }

  Widget _dateField(BuildContext context) {
    Future<void> pickDate() async {
      final selected = await selectDate(context);
      if (selected == null) {
        return;
      }

      setState(() {
        _checkedAtDisplay = convertDateFormatToDDMMYYYY(
          selected.toIso8601String(),
        );
      });
    }

    return Input(
      label: 'Data da conferência (opcional)',
      initialValue: _checkedAtDisplay,
      onChanged: (value) => setState(() => _checkedAtDisplay = value),
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        final regExp = RegExp(r'^[0-9]{2}/[0-9]{2}/[0-9]{4}$');
        return regExp.hasMatch(value) ? null : 'Informe no formato DD/MM/AAAA';
      },
      onTap: pickDate,
      onIconTap: pickDate,
      readOnly: true,
      iconRight: const Icon(
        Icons.calendar_today_outlined,
        color: AppColors.greyMiddle,
      ),
      keyboardType: TextInputType.datetime,
    );
  }

  Widget _notesField() {
    return Input(
      label: 'Notas (opcional)',
      initialValue: _notes,
      onChanged: (value) => setState(() => _notes = value),
      maxLines: 3,
    );
  }

  Widget _codeField(PatrimonyAssetDetailStore detailStore) {
    return Input(
      label: 'Código patrimonial',
      initialValue: _code,
      onChanged: (value) => setState(() => _code = value),
      onValidator:
          (value) =>
              value == null || value.trim().isEmpty ? 'Informe o código' : null,
      readOnly: detailStore.registeringInventory,
    );
  }

  Widget _quantityField(PatrimonyAssetDetailStore detailStore) {
    return Input(
      label: 'Quantidade',
      initialValue: _quantityText,
      onChanged: (value) => setState(() => _quantityText = value),
      onValidator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Informe a quantidade';
        }
        final parsed = int.tryParse(value);
        if (parsed == null || parsed <= 0) {
          return 'Quantidade inválida';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      readOnly: detailStore.registeringInventory,
    );
  }

  Future<void> _submit(PatrimonyAssetDetailStore detailStore) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final status = PatrimonyInventoryStatusCollection.apiValueFromLabel(
      _statusLabel,
    );

    if (status == null) {
      return;
    }

    final quantity = int.tryParse(_quantityText);
    if (quantity == null || quantity <= 0) {
      return;
    }

    final success = await detailStore.registerInventory(
      status: status,
      checkedAt:
          _checkedAtDisplay.isEmpty
              ? null
              : convertDateFormat(_checkedAtDisplay.trim()),
      notes: _notes.trim().isEmpty ? null : _notes.trim(),
      code: _code.trim(),
      quantity: quantity,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }
}
