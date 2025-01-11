import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/members/pages/add_members/widgets/form_member_inputs.dart';
import 'package:church_finance_bk/members/services/save_member_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'form_member_desktop_layout.dart';
import 'form_member_mobile.layout.dart';

class FormMember extends StatefulWidget {
  const FormMember({super.key});

  @override
  State<StatefulWidget> createState() => _FormMemberState();
}

class _FormMemberState extends State<FormMember> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            isMobile(context)
                ? formMemberMobileLayout(context)
                : formMemberDesktopLayout(context),
            const SizedBox(height: 32),
            isMobile(context)
                ? _btnSave()
                : Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 300,
                      child: _btnSave(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _btnSave() {
    return (formMemberState.makeRequest)
        ? const Loading()
        : Padding(
            padding: EdgeInsets.only(top: 20),
            child: CustomButton(
                text: "Salvar",
                backgroundColor: AppColors.green,
                textColor: Colors.black,
                onPressed: () => _saveRecord()));
  }

  void _saveRecord() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formMemberState.copyWith(makeRequest: true);
    final auth = await AuthPersistence().restore();

    SaveMemberService(tokenAPI: auth.token)
        .saveMember(formMemberState.toJson())
        .then((value) => {
              formMemberState.copyWith(makeRequest: false),
              GoRouter.of(context).go('/members')
            })
        .catchError((e) => formMemberState.copyWith(makeRequest: false));
  }
}
