import 'package:church_finance_bk/auth/auth_service.dart';
import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:church_finance_bk/auth/providers/auth_provider.dart';
import 'package:church_finance_bk/core/app_router.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/custom_input.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FormLogin extends ConsumerStatefulWidget {
  const FormLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormLogin();
}

class _FormLogin extends ConsumerState<FormLogin> {
  bool isPasswordVisible = true;
  late bool _makeRequest = false;
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
        print("form valid: $formValid");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    inputType: TextInputType.text,
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
        (_makeRequest) ? const Loading() : _buttonLogin(),
      ],
    );
  }

  Widget _buttonLogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: CustomButton(
          backgroundColor: AppColors.greenMiddle,
          text: "Entrar",
          onPressed: formValid ? _makeLogin : null,
          typeButton: CustomButton.basic),
    );
  }

  void _makeLogin() async {
    if (form.hasErrors) {
      form.markAllAsTouched();
      return;
    }

    setState(() {
      _makeRequest = true;
    });

    AuthSessionModel? session = await AuthService().makeLogin(
        form.value['email'].toString(), form.value['password'].toString());

    setState(() {
      _makeRequest = false;
    });

    if (session == null) {
      return;
    }

    await ref.read(sessionProvider.notifier).setSession(session);

    ref.read(appRouterProvider).go("/financial-movements");
  }
}
