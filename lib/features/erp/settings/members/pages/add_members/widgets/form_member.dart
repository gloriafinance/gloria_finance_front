import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:gloria_finance/features/erp/settings/members/pages/add_members/store/form_member_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'form_member_desktop_layout.dart';
import 'form_member_mobile.layout.dart';

class FormMember extends StatefulWidget {
  final bool isEditing;

  const FormMember({super.key, this.isEditing = false});

  @override
  State<StatefulWidget> createState() => _FormMemberState();
}

class _FormMemberState extends State<FormMember> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormMemberStore>(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            isMobile(context)
                ? formMemberMobileLayout(context, formStore)
                : formMemberDesktopLayout(context, formStore),
            const SizedBox(height: 32),
            isMobile(context)
                ? _btnSave(formStore)
                : Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(width: 300, child: _btnSave(formStore)),
                ),
          ],
        ),
      ),
    );
  }

  Widget _btnSave(FormMemberStore formStore) {
    return (formStore.state.makeRequest)
        ? const Loading()
        : Padding(
          padding: EdgeInsets.only(top: 20),
          child: CustomButton(
            text: widget.isEditing ? "Atualizar" : "Salvar",
            backgroundColor: AppColors.green,
            textColor: Colors.black,
            onPressed: () => _saveRecord(formStore),
          ),
        );
  }

  void _saveRecord(FormMemberStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    var response = await formStore.save();
    if (response) {
      GoRouter.of(context).go('/members');
    }
  }
}
