import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:flutter/material.dart';

typedef CreateUserResult =
    ({String name, String email, String password, bool isActive});

class FormCreateUser extends StatefulWidget {
  const FormCreateUser({super.key});

  @override
  State<FormCreateUser> createState() => _FormCreateUserState();
}

class _FormCreateUserState extends State<FormCreateUser> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = 'ChangeMe123!';
  String _confirmPassword = 'ChangeMe123!';
  bool _isActive = true;

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    Navigator.of(context).pop<CreateUserResult>((
      name: _name.trim(),
      email: _email.trim(),
      password: _password.trim(),
      isActive: _isActive,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Input(
                  label: 'Nome completo',
                  icon: Icons.person_outline,
                  onChanged: (value) => _name = value,
                  onValidator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o nome.';
                    }
                    return null;
                  },
                ),
                Input(
                  label: 'E-mail',
                  icon: Icons.mail_outline,
                  onChanged: (value) => _email = value,
                  keyboardType: TextInputType.emailAddress,
                  onValidator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o e-mail.';
                    }
                    if (!value.contains('@')) {
                      return 'E-mail inválido.';
                    }
                    return null;
                  },
                ),
                Input(
                  label: 'Senha inicial',
                  icon: Icons.lock_outline,
                  isPass: true,
                  initialValue: _password,
                  onChanged: (value) => _password = value,
                  onValidator: (value) {
                    if (value == null || value.trim().length < 8) {
                      return 'Mínimo de 8 caracteres.';
                    }
                    return null;
                  },
                ),
                Input(
                  label: 'Confirmar senha',
                  icon: Icons.lock_reset,
                  isPass: true,
                  initialValue: _confirmPassword,
                  onChanged: (value) => _confirmPassword = value,
                  onValidator: (value) {
                    if (value != _password) {
                      return 'As senhas não coincidem.';
                    }
                    return null;
                  },
                ),
                SwitchListTile.adaptive(
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                  title: const Text('Usuário ativo'),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                CustomButton(
                  backgroundColor: AppColors.green,
                  text: 'Criar usuário',
                  icon: Icons.person_add_alt,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
