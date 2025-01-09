import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/members/pages/add_members/widgets/form_member_inputs.dart';
import 'package:flutter/material.dart';

import 'form_member_desktop_layout.dart';

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
            formMemberDesktopLayout(context),
            const SizedBox(height: 32),
            _btnSave(),
          ],
        ),
      ),
    );
  }

  Widget _btnSave() {
    return (formMemberState.makeRequest)
        ? const Loading()
        : Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: CustomButton(
                    text: "Salvar",
                    backgroundColor: AppColors.green,
                    textColor: Colors.black,
                    onPressed: () => _saveRecord())),
          );
  }

  void _saveRecord() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formMemberState.copyWith(makeRequest: true);
  }
}
