import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../store/auth_session_store.dart';
import '../validators/form_login_validator.dart';

class FormEmailLogin extends StatefulWidget {
  const FormEmailLogin({super.key});

  @override
  State<StatefulWidget> createState() => _FormEmailLoginState();
}

class _FormEmailLoginState extends State<FormEmailLogin> {
  final formKey = GlobalKey<FormState>();
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
    final validator = FormLoginValidator(
      invalidEmailMessage: context.l10n.auth_login_error_invalid_email,
      requiredPasswordMessage: context.l10n.auth_login_error_required_password,
    );

    final authStore = Provider.of<AuthSessionStore>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Form(
        key: formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 23, 10, 0),
                  child: Input(
                    icon: Icons.email_outlined,
                    label: context.l10n.auth_login_email_label,
                    keyboardType: TextInputType.emailAddress,
                    onValidator: validator.byField(
                      authStore.formState,
                      'email',
                    ),
                    onChanged: (value) {
                      authStore.setEmail(value);
                      _validateForm();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                  child: Input(
                    label: context.l10n.auth_login_password_label,
                    icon: Icons.lock_outline,
                    keyboardType: TextInputType.text,
                    iconRight: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: AppColors.mustard,
                    ),
                    isPass: isPasswordVisible,
                    onIconTap: _handleSuffixIconTap,
                    onValidator: validator.byField(
                      authStore.formState,
                      'password',
                    ),
                    onChanged: (value) {
                      authStore.setPassword(value);
                      _validateForm();
                    },
                  ),
                ),
                const SizedBox(height: 32),
                _forgetPassword(),
                (authStore.formState.makeRequest)
                    ? const Loading()
                    : _buttonLogin(authStore),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _forgetPassword() {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go('/recovery-password');
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          context.l10n.auth_login_forgot_password,
          style: const TextStyle(
            color: AppColors.purple,
            fontSize: 16,
            fontFamily: AppFonts.fontSubTitle,
          ),
        ),
      ),
    );
  }

  Widget _buttonLogin(AuthSessionStore authStore) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: CustomButton(
        backgroundColor: AppColors.green,
        text: context.l10n.auth_login_submit,
        onPressed: isFormValid ? () => _makeLogin(authStore) : null,
        typeButton: CustomButton.basic,
      ),
    );
  }

  void _makeLogin(AuthSessionStore authStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (await authStore.login()) {
      // Check if user needs to accept policies before proceeding
      if (authStore.needsPolicyAcceptance()) {
        context.go('/policy-acceptance');
      } else {
        context.go('/dashboard');
      }
    }
  }
}
