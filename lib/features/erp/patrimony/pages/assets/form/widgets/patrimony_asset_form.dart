import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/features/erp/settings/members/store/member_all_store.dart';
import 'package:church_finance_bk/features/erp/patrimony/models/patrimony_asset_enums.dart';
import 'package:church_finance_bk/features/erp/patrimony/pages/assets/form/store/patrimony_asset_form_store.dart';
import 'package:church_finance_bk/features/erp/patrimony/pages/assets/form/widgets/patrimony_attachments_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

        final valueInitial =
            state.valueText.isNotEmpty
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

  Widget _responsiveGrid(
    BuildContext context,
    PatrimonyAssetFormStore store,
    String valueInitial,
  ) {
    final categoryItems =
        PatrimonyAssetCategory.values.map((e) => e.label).toList();
    final statusItems = PatrimonyAssetStatusCollection.labels(
      includeDisposal: false,
    );

    final fields = [
      Input(
        label: 'Código patrimonial',
        initialValue: store.state.code,
        onChanged: store.setCode,
        onValidator:
            (value) =>
                (value == null || value.trim().isEmpty)
                    ? 'Informe o código patrimonial'
                    : null,
        readOnly: store.state.isEditing,
      ),
      Input(
        label: 'Nome do bem',
        initialValue: store.state.name,
        onChanged: store.setName,
        onValidator:
            (value) =>
                (value == null || value.trim().isEmpty)
                    ? 'Informe o nome do bem'
                    : null,
      ),
      Input(
        label: 'Quantidade',
        initialValue: store.state.quantityText,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: store.setQuantityFromInput,
        onValidator:
            (_) => store.state.quantity <= 0 ? 'Informe a quantidade' : null,
        readOnly: store.state.isEditing,
      ),
      Dropdown(
        label: 'Categoria',
        initialValue: store.state.categoryLabel,
        items: categoryItems,
        onChanged: store.setCategoryByLabel,
        onValidator:
            (_) =>
                store.state.category == null ? 'Selecione uma categoria' : null,
        labelSuffix: _clearSuffix(
          () => store.setCategoryByLabel(null),
          visible: store.state.category != null,
        ),
      ),
      Input(
        label: 'Valor estimado',
        initialValue: valueInitial,
        keyboardType: TextInputType.number,
        inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
        onChanged: store.setValueFromInput,
        onValidator:
            (_) =>
                store.state.value <= 0
                    ? 'Informe um valor maior que zero'
                    : null,
      ),
      Input(
        label: 'Data de aquisição',
        initialValue: store.state.acquisitionDate,
        keyboardType: TextInputType.number,
        onChanged: store.setAcquisitionDate,
        onValidator:
            (value) =>
                (value == null || value.isEmpty)
                    ? 'Informe a data de aquisição'
                    : null,
        onTap: () async {
          final picked = await selectDate(context);
          if (picked == null) return;
          final formatted = convertDateFormatToDDMMYYYY(
            picked.toIso8601String(),
          );
          store.setAcquisitionDate(formatted);
        },
      ),
      Input(
        label: 'Localização física',
        initialValue: store.state.location,
        onChanged: store.setLocation,
        onValidator:
            (value) =>
                (value == null || value.trim().isEmpty)
                    ? 'Informe a localização atual'
                    : null,
      ),
      _responsibleSelector(store),
      Dropdown(
        label: 'Status',
        initialValue: store.state.statusLabel,
        items: statusItems,
        onChanged: store.setStatusByLabel,
        onValidator:
            (_) =>
                store.state.status == null ? 'Selecione o status do bem' : null,
        labelSuffix: _clearSuffix(
          () => store.setStatusByLabel(null),
          visible: store.state.status != null,
        ),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 720;
        final double fieldWidth =
            isSmall ? constraints.maxWidth : (constraints.maxWidth / 2) - 20;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              fields
                  .map((field) => SizedBox(width: fieldWidth, child: field))
                  .toList(),
        );
      },
    );
  }

  Widget _responsibleSelector(PatrimonyAssetFormStore store) {
    return Consumer<MemberAllStore>(
      builder: (context, memberStore, _) {
        final members = memberStore.getMembers();
        final items = members.map((member) => member.name).toList();

        String? selectedName;
        if (store.state.responsibleId.isNotEmpty) {
          for (final member in members) {
            if (member.memberId == store.state.responsibleId) {
              selectedName = member.name;
              break;
            }
          }
        }

        return Dropdown(
          label: 'Responsável',
          items: items,
          initialValue: selectedName,
          searchHint: 'Busque pelo nome do membro...',
          onChanged: (selected) {
            if (members.isEmpty) {
              store.setResponsibleId(null);
              return;
            }

            final member = members.firstWhere(
              (m) => m.name == selected,
              orElse: () => members.first,
            );
            store.setResponsibleId(member.memberId);
          },
          onValidator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? 'Selecione o responsável pelo bem'
                      : null,
        );
      },
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
                ToastType.info,
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
