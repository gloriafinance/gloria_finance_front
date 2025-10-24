import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/cost_center/models/cost_center_model.dart';
import 'package:church_finance_bk/settings/cost_center/pages/cost_center_form/store/cost_center_form_store.dart';
import 'package:church_finance_bk/settings/cost_center/store/cost_center_list_store.dart';
import 'package:church_finance_bk/settings/members/models/member_model.dart';
import 'package:church_finance_bk/settings/members/store/member_all_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CostCenterForm extends StatefulWidget {
  const CostCenterForm({super.key});

  @override
  State<CostCenterForm> createState() => _CostCenterFormState();
}

class _CostCenterFormState extends State<CostCenterForm> {
  static const int _costCenterIdMaxLength = 12;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formStore = context.watch<CostCenterFormStore>();
    final membersStore = context.watch<MemberAllStore>();

    final members = membersStore.getMembers();
    final memberOptions = members
        .map((member) => _buildMemberDisplayName(member))
        .toList(growable: false);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: isMobile(context)
            ? _buildMobileLayout(formStore, members, memberOptions)
            : _buildDesktopLayout(formStore, members, memberOptions),
      ),
    );
  }

  Widget _buildMobileLayout(
    CostCenterFormStore formStore,
    List<MemberModel> members,
    List<String> memberOptions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCostCenterIdField(formStore),
        _buildNameField(formStore),
        _buildCategoryField(formStore),
        _buildResponsibleField(formStore, members, memberOptions),
        _buildDescriptionField(formStore),
        const SizedBox(height: 16),
        _buildActiveToggle(formStore),
        const SizedBox(height: 24),
        _buildSubmitButton(formStore),
      ],
    );
  }

  Widget _buildDesktopLayout(
    CostCenterFormStore formStore,
    List<MemberModel> members,
    List<String> memberOptions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCostCenterIdField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildNameField(formStore)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCategoryField(formStore)),
            const SizedBox(width: 24),
            Expanded(
              child:
                  _buildResponsibleField(formStore, members, memberOptions),
            ),
          ],
        ),
        _buildDescriptionField(formStore),
        const SizedBox(height: 16),
        _buildActiveToggle(formStore),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(width: 300, child: _buildSubmitButton(formStore)),
        ),
      ],
    );
  }

  Widget _buildCostCenterIdField(CostCenterFormStore formStore) {
    return Input(
      label: 'Código',
      labelSuffix: _buildCostCenterIdHelpIcon(),
      initialValue: formStore.state.costCenterId,
      onValidator: _requiredValidator,
      onChanged: formStore.setCostCenterId,
      inputFormatters: [
        LengthLimitingTextInputFormatter(_costCenterIdMaxLength),
      ],
    );
  }

  Widget _buildNameField(CostCenterFormStore formStore) {
    return Input(
      label: 'Nome',
      initialValue: formStore.state.name,
      onValidator: _requiredValidator,
      onChanged: formStore.setName,
    );
  }

  Widget _buildCategoryField(CostCenterFormStore formStore) {
    return Dropdown(
      label: 'Categoria',
      initialValue: formStore.state.category?.friendlyName,
      items: CostCenterCategory.values
          .map((type) => type.friendlyName)
          .toList(growable: false),
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione a categoria';
        }
        return null;
      },
      onChanged: (value) {
        final selected = CostCenterCategory.values.firstWhere(
          (element) => element.friendlyName == value,
        );
        formStore.setCategory(selected);
      },
    );
  }

  Widget _buildResponsibleField(
    CostCenterFormStore formStore,
    List<MemberModel> members,
    List<String> memberOptions,
  ) {
    final responsibleId = formStore.state.responsibleMemberId;
    final responsibleName = formStore.state.responsibleMemberName;

    if (memberOptions.isNotEmpty) {
      int selectedIndex = -1;

      if (responsibleId != null) {
        selectedIndex =
            members.indexWhere((member) => member.memberId == responsibleId);
      } else if (responsibleName != null && responsibleName.isNotEmpty) {
        selectedIndex = memberOptions.indexOf(responsibleName);
      }

      if (selectedIndex != -1) {
        final expectedDisplayName = memberOptions[selectedIndex];
        final selectedMember = members[selectedIndex];

        final shouldUpdateId =
            formStore.state.responsibleMemberId != selectedMember.memberId;
        final shouldUpdateName =
            formStore.state.responsibleMemberName != expectedDisplayName;

        if (shouldUpdateId || shouldUpdateName) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            formStore.setResponsibleMember(
              selectedMember,
              expectedDisplayName,
            );
          });
        }
      }
    }

    if (memberOptions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          'Nenhum membro disponível. Cadastre um membro antes de continuar.',
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      );
    }

    return Dropdown(
      label: 'Responsável',
      initialValue: formStore.state.responsibleMemberName,
      items: memberOptions,
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione o responsável';
        }
        return null;
      },
      onChanged: (value) {
        final selectedIndex = memberOptions.indexOf(value);
        if (selectedIndex == -1) {
          return;
        }

        final member = members[selectedIndex];
        formStore.setResponsibleMember(member, value);
      },
    );
  }

  Widget _buildDescriptionField(CostCenterFormStore formStore) {
    return Input(
      label: 'Descrição',
      labelSuffix: _buildDescriptionHelpIcon(),
      initialValue: formStore.state.description,
      onValidator: _requiredValidator,
      onChanged: formStore.setDescription,
    );
  }

  Widget _buildCostCenterIdHelpIcon() {
    return Tooltip(
      message:
          'Use um código fácil de lembrar com até $_costCenterIdMaxLength caracteres.',
      child: const Padding(
        padding: EdgeInsets.all(2.0),
        child: Icon(
          Icons.help_outline,
          size: 18,
          color: AppColors.purple,
        ),
      ),
    );
  }

  Widget _buildDescriptionHelpIcon() {
    return const Tooltip(
      message:
          'Descreva de forma objetiva como este centro de custo será utilizado.',
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Icon(
          Icons.help_outline,
          size: 18,
          color: AppColors.purple,
        ),
      ),
    );
  }

  Widget _buildActiveToggle(CostCenterFormStore formStore) {
    return Row(
      children: [
        const Text(
          'Ativo',
          style: TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
          ),
        ),
        Switch(
          value: formStore.state.active,
          onChanged: formStore.setActive,
          activeColor: AppColors.green,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(CostCenterFormStore formStore) {
    if (formStore.state.makeRequest) {
      return const Loading();
    }

    return CustomButton(
      text: formStore.state.isEdit ? 'Atualizar' : 'Salvar',
      backgroundColor: AppColors.green,
      textColor: Colors.black,
      onPressed: () => _save(formStore),
    );
  }

  Future<void> _save(CostCenterFormStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (formStore.state.responsibleMemberId == null) {
      Toast.showMessage(
        'Selecione um responsável para o centro de custo',
        ToastType.error,
      );
      return;
    }

    final success = await formStore.submit();

    if (success && mounted) {
      Toast.showMessage(
        formStore.state.isEdit
            ? 'Registro atualizado com sucesso'
            : 'Registro salvo com sucesso',
        ToastType.info,
      );
      final listStore = context.read<CostCenterListStore>();
      await listStore.searchCostCenters();
      context.go('/cost-center');
    }
  }

  String _buildMemberDisplayName(MemberModel member) {
    final buffer = StringBuffer(member.name);
    if (member.email.isNotEmpty) {
      buffer.write(' • ');
      buffer.write(member.email);
    }
    return buffer.toString();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}
