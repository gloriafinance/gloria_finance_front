import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../store/auth_session_store.dart';
import '../validators/form_login_validator.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<StatefulWidget> createState() => _FormLogin();
}

class _FormLogin extends State<FormLogin> {
  final formKey = GlobalKey<FormState>();
  final validator = FormLoginValidator();
  bool isPasswordVisible = true;
  bool isFormValid = false;

  void _handleSuffixIconTap() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void _validateForm() {
    setState(() {
      isFormValid = formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthSessionStore>(context);

    return Form(
      key: formKey,
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 23, 10, 0),
              child: Input(
                label: "E-mail",
                keyboardType: TextInputType.emailAddress,
                onValidator: validator.byField(authStore.formState, 'email'),
                onChanged: (value) {
                  authStore.setEmail(value);
                  _validateForm();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
              child: Input(
                label: "Senha",
                keyboardType: TextInputType.text,
                iconRight: const Icon(
                  Icons.remove_red_eye_outlined,
                  color: AppColors.mustard,
                ),
                isPass: isPasswordVisible,
                onIconTap: _handleSuffixIconTap,
                onValidator: validator.byField(authStore.formState, 'password'),
                onChanged: (value) {
                  authStore.setPassword(value);
                  _validateForm();
                },
              ),
            ),
            (authStore.formState.makeRequest)
                ? const Loading()
                : _buttonLogin(authStore, context),
          ],
        );
      }),
    );
  }

  Widget _buttonLogin(AuthSessionStore authStore, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: CustomButton(
          backgroundColor: AppColors.green,
          text: "Entrar",
          onPressed: isFormValid ? () => _makeLogin(authStore, context) : null,
          typeButton: CustomButton.basic),
    );
  }

  void _makeLogin(AuthSessionStore authStore, BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (await authStore.login()) {
      GoRouter.of(context).go('/dashboard');
    }
  }
}
