import 'package:church_finance_bk/auth/stores/auth_session_store.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/custom_input.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<StatefulWidget> createState() => _FormLogin();
}

class _FormLogin extends State<FormLogin> {
  bool isPasswordVisible = true;
  bool redirectToDashboard = false;
  bool formValid = true;

  final form = FormGroup({
    'email': FormControl(
      value: 'angel@gmail.com',
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
        value: '123angel', validators: [Validators.required])
  });

  void _handleSuffixIconTap() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Escuchar cambios en el formulario y actualizar el estado de la validación
    form.valueChanges.listen((value) {
      setState(() {
        // Actualiza el estado cuando el formulario cambia
        formValid = form.valid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthSessionStore>(context);

    return Column(
      children: [
        ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 23, 10, 0),
                child: CustomInput(
                    formControlName: "email",
                    label: "E-mail",
                    inputType: TextInputType.emailAddress,
                    placeholder: "E-mail"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                child: CustomInput(
                  formControlName: "password",
                  label: "Senha",
                  inputType: TextInputType.text,
                  placeholder: "Senha",
                  iconRigth: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: AppColors.mustard,
                  ),
                  isPass: isPasswordVisible,
                  onTap: _handleSuffixIconTap,
                ),
              ),
            ],
          ),
        ),
        (authStore.state.makeRequest)
            ? const Loading()
            : _buttonLogin(authStore, context),
      ],
    );
  }

  Widget _buttonLogin(AuthSessionStore authStore, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: CustomButton(
          backgroundColor: AppColors.green,
          text: "Entrar",
          onPressed: formValid ? () => _makeLogin(authStore, context) : null,
          //textColor: Colors.black87,
          typeButton: CustomButton.basic),
    );
  }

  void _makeLogin(AuthSessionStore authStore, BuildContext context) async {
    if (form.hasErrors) {
      form.markAllAsTouched();
      return;
    }

    if (await authStore.login(
        form.value['email'].toString(), form.value['password'].toString())) {
      GoRouter.of(context).go('/dashboard');
    }
  }
}
