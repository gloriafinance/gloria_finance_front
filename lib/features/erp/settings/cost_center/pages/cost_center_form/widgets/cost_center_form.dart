import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/features/erp/settings/cost_center/models/cost_center_model.dart';
import 'package:church_finance_bk/features/erp/settings/cost_center/pages/cost_center_form/store/cost_center_form_store.dart';
import 'package:church_finance_bk/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:church_finance_bk/features/erp/settings/members/models/member_model.dart';
import 'package:church_finance_bk/features/erp/settings/members/store/member_all_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CostCenterForm extends StatefulWidget {
  final bool isEdit;

  const CostCenterForm({super.key, required this.isEdit});

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
    final memberLookup = <String, MemberModel>{
      for (final member in members) _buildMemberDisplayName(member): member,
    };

    final memberOptions = memberLookup.keys.toList(growable: false);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child:
            isMobile(context)
                ? _buildMobileLayout(formStore, memberLookup, memberOptions)
                : _buildDesktopLayout(formStore, memberLookup, memberOptions),
      ),
    );
  }

  Widget _buildMobileLayout(
    CostCenterFormStore formStore,
    Map<String, MemberModel> memberLookup,
    List<String> memberOptions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCostCenterIdField(formStore),
        _buildNameField(formStore),
        _buildCategoryField(formStore),
        _buildResponsibleField(formStore, memberLookup, memberOptions),
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
    Map<String, MemberModel> memberLookup,
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
              child: _buildResponsibleField(
                formStore,
                memberLookup,
                memberOptions,
              ),
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
      label: context.l10n.settings_cost_center_field_code,
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
      label: context.l10n.settings_cost_center_field_name,
      initialValue: formStore.state.name,
      onValidator: _requiredValidator,
      onChanged: formStore.setName,
    );
  }

  Widget _buildCategoryField(CostCenterFormStore formStore) {
    return Dropdown(
      label: context.l10n.settings_cost_center_field_category,
      initialValue: formStore.state.category?.friendlyName(context.l10n),
      items: CostCenterCategory.values
          .map((type) => type.friendlyName(context.l10n))
          .toList(growable: false),
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.settings_cost_center_error_select_category;
        }
        return null;
      },
      onChanged: (value) {
        final selected = CostCenterCategory.values.firstWhere(
          (element) => element.friendlyName(context.l10n) == value,
        );
        formStore.setCategory(selected);
      },
    );
  }

  Widget _buildResponsibleField(
    CostCenterFormStore formStore,
    Map<String, MemberModel> memberLookup,
    List<String> memberOptions,
  ) {
    if (memberOptions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          context.l10n.settings_cost_center_error_select_responsible,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      );
    }

    return Dropdown(
      label: context.l10n.settings_cost_center_field_responsible,
      initialValue: _resolveResponsibleLabel(
        formStore,
        memberLookup,
        memberOptions,
      ),
      items: memberOptions,
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.settings_cost_center_error_select_responsible;
        }
        return null;
      },
      onChanged: (value) {
        final selectedIndex = memberOptions.indexOf(value);
        if (selectedIndex == -1) {
          return;
        }

        final member = memberLookup[value];
        if (member == null) {
          return;
        }

        formStore.setResponsibleMember(member, value);
      },
    );
  }

  String? _resolveResponsibleLabel(
    CostCenterFormStore formStore,
    Map<String, MemberModel> memberLookup,
    List<String> memberOptions,
  ) {
    final responsibleId = formStore.state.responsibleMemberId;
    if (responsibleId != null && responsibleId.isNotEmpty) {
      for (final entry in memberLookup.entries) {
        if (entry.value.memberId == responsibleId) {
          return entry.key;
        }
      }
    }

    final currentLabel = formStore.state.responsibleMemberName;
    if (currentLabel != null && memberOptions.contains(currentLabel)) {
      return currentLabel;
    }

    return null;
  }

  Widget _buildDescriptionField(CostCenterFormStore formStore) {
    return Input(
      label: context.l10n.settings_cost_center_field_description,
      labelSuffix: _buildDescriptionHelpIcon(),
      initialValue: formStore.state.description,
      onValidator: _requiredValidator,
      onChanged: formStore.setDescription,
    );
  }

  Widget _buildCostCenterIdHelpIcon() {
    // return Tooltip(
    //   message: context.l10n.settings_cost_center_help_code(
    //     _costCenterIdMaxLength,
    //   ),
    //   child: const Padding(
    //     padding: EdgeInsets.all(2.0),
    //     child: Icon(Icons.help_outline, size: 18, color: AppColors.purple),
    //   ),
    // );
    return quickHelp(
      context.l10n.settings_cost_center_help_code(_costCenterIdMaxLength),
    );
  }

  Widget _buildDescriptionHelpIcon() {
    // return Tooltip(
    //   message: context.l10n.settings_cost_center_help_description,
    //   child: const Padding(
    //     padding: EdgeInsets.all(2.0),
    //     child: Icon(Icons.help_outline, size: 18, color: AppColors.purple),
    //   ),
    // );
    return quickHelp(context.l10n.settings_cost_center_help_description);
  }

  Widget quickHelp(String messae) {
    return Tooltip(
      message: messae,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(243, 205, 51, 0.51),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Icon(Icons.help_outline, size: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildActiveToggle(CostCenterFormStore formStore) {
    return Row(
      children: [
        Text(
          context.l10n.settings_cost_center_field_active,
          style: const TextStyle(
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
      text:
          formStore.state.isEdit
              ? context.l10n.settings_cost_center_update
              : context.l10n.settings_cost_center_save,
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
        context.l10n.settings_cost_center_error_select_responsible,
        ToastType.error,
      );
      return;
    }

    final success = await formStore.submit(widget.isEdit);

    if (success && mounted) {
      if (formStore.state.isEdit) {
        Toast.showMessage(
          context.l10n.settings_cost_center_toast_updated,
          ToastType.info,
        );
      } else {
        Toast.showMessage(
          context.l10n.settings_cost_center_toast_saved,
          ToastType.info,
        );
      }
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
    return buffer.toString().trim();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.settings_cost_center_error_required;
    }
    return null;
  }
}
