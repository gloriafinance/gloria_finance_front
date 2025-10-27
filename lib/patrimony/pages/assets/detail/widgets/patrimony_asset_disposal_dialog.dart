import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
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

  String? _statusLabel;
  String _reason = '';
  String _disposedAtDisplay = '';
  String _notes = '';

  @override
  Widget build(BuildContext context) {
    final detailStore = context.watch<PatrimonyAssetDetailStore>();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
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
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.end,
              children: [
                AbsorbPointer(
                  absorbing: detailStore.registeringDisposal,
                  child: ButtonActionTable(
                    color: AppColors.greyMiddle,
                    text: 'Cancelar',
                    icon: Icons.close,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                AbsorbPointer(
                  absorbing: detailStore.registeringDisposal,
                  child: ButtonActionTable(
                    color: AppColors.purple,
                    text: detailStore.registeringDisposal
                        ? 'Registrando...'
                        : 'Confirmar',
                    icon: detailStore.registeringDisposal
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
    final options = PatrimonyAssetStatusCollection.disposalLabels();

    return Dropdown(
      label: 'Status da baixa',
      items: options,
      initialValue: _statusLabel,
      onChanged: (value) => setState(() => _statusLabel = value),
      onValidator: (value) =>
          value == null || value.isEmpty ? 'Selecione um status' : null,
    );
  }

  Widget _reasonField() {
    return Input(
      label: 'Motivo',
      initialValue: _reason,
      onChanged: (value) => setState(() => _reason = value),
      onValidator: (value) =>
          value == null || value.trim().isEmpty ? 'Informe o motivo da baixa' : null,
      maxLines: 2,
    );
  }

  Widget _dateField(BuildContext context) {
    Future<void> pickDate() async {
      final selected = await selectDate(context);
      if (selected == null) {
        return;
      }

      setState(() {
        _disposedAtDisplay =
            convertDateFormatToDDMMYYYY(selected.toIso8601String());
      });
    }

    return Input(
      label: 'Data da baixa (opcional)',
      initialValue: _disposedAtDisplay,
      onChanged: (value) => setState(() => _disposedAtDisplay = value),
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
      label: 'Observações (opcional)',
      initialValue: _notes,
      onChanged: (value) => setState(() => _notes = value),
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

    String? disposedAt;
    if (_disposedAtDisplay.isNotEmpty) {
      disposedAt = convertDateFormat(_disposedAtDisplay.trim());
    }

    final notes = _notes.trim().isEmpty ? null : _notes.trim();

    final success = await detailStore.registerDisposal(
      status: status,
      reason: _reason.trim(),
      disposedAt: disposedAt,
      observations: notes,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

}
