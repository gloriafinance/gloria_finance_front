import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/helpers/currency_formatter.dart';
import 'package:church_finance_bk/helpers/date_formatter.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_asset_enums.dart';
import 'package:church_finance_bk/patrimony/pages/assets/form/store/patrimony_asset_form_store.dart';
import 'package:church_finance_bk/patrimony/pages/assets/form/widgets/patrimony_attachments_editor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PatrimonyAssetForm extends StatefulWidget {
  const PatrimonyAssetForm({super.key});

  @override
  State<PatrimonyAssetForm> createState() => _PatrimonyAssetFormState();
}

class _PatrimonyAssetFormState extends State<PatrimonyAssetForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<PatrimonyAssetFormStore>(
      builder: (context, store, _) {
        final state = store.state;

        if (state.loadingAsset) {
          return const Center(child: CircularProgressIndicator());
        }

        final valueInitial = state.valueText.isNotEmpty
            ? state.valueText
            : (state.value > 0
                ? CurrencyFormatter.formatCurrency(state.value)
                : '');

        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _responsiveGrid(context, store, valueInitial),
              const SizedBox(height: 24),
              const PatrimonyAttachmentsEditor(),
              const SizedBox(height: 24),
              _notesField(store),
              const SizedBox(height: 32),
              _submitButton(store),
            ],
          ),
        );
      },
    );
  }

  Widget _responsiveGrid(BuildContext context, PatrimonyAssetFormStore store, String valueInitial) {
    final fields = [
      Input(
        label: 'Nome do bem',
        initialValue: store.state.name,
        onChanged: store.setName,
        onValidator: (value) => (value == null || value.trim().isEmpty)
            ? 'Informe o nome do bem'
            : null,
      ),
      Dropdown(
        label: 'Categoria',
        initialValue: store.state.categoryLabel,
        items: PatrimonyAssetCategory.values.map((e) => e.label).toList(),
        onChanged: store.setCategoryByLabel,
        onValidator: (_) => store.state.category == null
            ? 'Selecione uma categoria'
            : null,
        labelSuffix: _clearSuffix(() => store.setCategoryByLabel(null),
            visible: store.state.category != null),
      ),
      Input(
        label: 'Valor estimado',
        initialValue: valueInitial,
        keyboardType: TextInputType.number,
        inputFormatters: [
          CurrencyFormatter.getInputFormatters('R\$'),
        ],
        onChanged: store.setValueFromInput,
        onValidator: (_) => store.state.value <= 0
            ? 'Informe um valor maior que zero'
            : null,
      ),
      Input(
        label: 'Data de aquisição',
        initialValue: store.state.acquisitionDate,
        keyboardType: TextInputType.number,
        onChanged: store.setAcquisitionDate,
        onValidator: (value) => (value == null || value.isEmpty)
            ? 'Informe a data de aquisição'
            : null,
        onTap: () async {
          final picked = await selectDate(context);
          if (picked == null) return;
          final formatted = convertDateFormatToDDMMYYYY(picked.toIso8601String());
          store.setAcquisitionDate(formatted);
        },
      ),
      Input(
        label: 'Congregação (churchId)',
        initialValue: store.state.churchId,
        onChanged: store.setChurchId,
        onValidator: (value) => (value == null || value.trim().isEmpty)
            ? 'Informe o identificador da congregação'
            : null,
      ),
      Input(
        label: 'Localização física',
        initialValue: store.state.location,
        onChanged: store.setLocation,
        onValidator: (value) => (value == null || value.trim().isEmpty)
            ? 'Informe a localização atual'
            : null,
      ),
      Input(
        label: 'Responsável (ID)',
        initialValue: store.state.responsibleId,
        onChanged: store.setResponsibleId,
        onValidator: (value) => (value == null || value.trim().isEmpty)
            ? 'Informe o responsável pelo bem'
            : null,
      ),
      Dropdown(
        label: 'Status',
        initialValue: store.state.statusLabel,
        items: PatrimonyAssetStatus.values.map((e) => e.label).toList(),
        onChanged: store.setStatusByLabel,
        onValidator: (_) => store.state.status == null
            ? 'Selecione o status do bem'
            : null,
        labelSuffix: _clearSuffix(() => store.setStatusByLabel(null),
            visible: store.state.status != null),
      ),
    ];

    if (isMobile(context)) {
      return Column(
        children: [
          for (final field in fields) ...[
            field,
          ],
        ],
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: fields
          .map(
            (field) => SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 60,
              child: field,
            ),
          )
          .toList(),
    );
  }

  Widget _notesField(PatrimonyAssetFormStore store) {
    return Input(
      label: 'Observações',
      initialValue: store.state.notes,
      onChanged: store.setNotes,
    );
  }

  Widget _submitButton(PatrimonyAssetFormStore store) {
    if (store.state.makeRequest) {
      return const Loading();
    }

    return Align(
      alignment: isMobile(context) ? Alignment.center : Alignment.centerRight,
      child: SizedBox(
        width: isMobile(context) ? double.infinity : 260,
        child: CustomButton(
          text: store.state.isEditing ? 'Salvar alterações' : 'Registrar bem',
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          onPressed: () async {
            if (!formKey.currentState!.validate()) {
              Toast.showMessage(
                'Revise os campos obrigatórios antes de continuar.',
                ToastType.warning,
              );
              return;
            }

            final success = await store.submit();
            if (success) {
              Toast.showMessage(
                store.state.isEditing
                    ? 'Bem atualizado com sucesso'
                    : 'Bem cadastrado com sucesso',
                ToastType.success,
              );
              GoRouter.of(context).go('/patrimony/assets');
            } else {
              Toast.showMessage(
                'Não foi possível salvar o bem. Tente novamente.',
                ToastType.error,
              );
            }
          },
        ),
      ),
    );
  }

  Widget? _clearSuffix(VoidCallback onPressed, {required bool visible}) {
    if (!visible) return null;

    return GestureDetector(
      onTap: onPressed,
      child: const Icon(Icons.close, size: 18, color: AppColors.greyMiddle),
    );
  }
}
