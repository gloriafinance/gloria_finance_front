import 'package:church_finance_bk/auth/pages/recovery_password/store/change_password_store.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../validator/change_password_validator.dart';

class FormChangePassword extends StatefulWidget {
  const FormChangePassword({super.key});

  @override
  State<StatefulWidget> createState() => _FormChangePasswordState();
}

class _FormChangePasswordState extends State<FormChangePassword> {
  final formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  final validator = ChangePasswordValidator();

  void _validateForm() {
    setState(() {
      isFormValid = formKey.currentState?.validate() ?? false;

      print(isFormValid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangePasswordStore>(context);

    return Form(
        key: formKey,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
              child: Input(
                isPass: true,
                label: "Senha anterior",
                icon: Icons.lock_outline,
                keyboardType: TextInputType.text,
                onValidator: validator.byField(store.state, 'oldPassword'),
                onChanged: (value) {
                  store.setOldPassword(value);
                  _validateForm();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
              child: Input(
                isPass: true,
                label: "Nova senha",
                icon: Icons.lock_outline,
                keyboardType: TextInputType.text,
                onValidator: validator.byField(store.state, 'newPassword'),
                onChanged: (value) {
                  store.setNewPassword(value);
                  _validateForm();
                },
              ),
            ),
            SizedBox(height: 32),
            store.state.makeRequest ? Loading() : _sendButton(store),
          ]);
        }));
  }

  Widget _sendButton(ChangePasswordStore store) {
    return CustomButton(
      text: "Enviar",
      backgroundColor: AppColors.green,
      onPressed: isFormValid ? () => _makeChangePassword(store) : null,
    );
  }

  void _makeChangePassword(ChangePasswordStore store) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    store.changePassword().then((success) {
      if (success) {
        GoRouter.of(context).go('/');
      }
    });
  }
}
