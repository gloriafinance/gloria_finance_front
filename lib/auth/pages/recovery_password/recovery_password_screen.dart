import 'package:church_finance_bk/auth/widgets/layout_auth.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/app_logo.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';

class RecoveryPasswordScreen extends StatelessWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutAuth(
        child: Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Color de fondo del contenedor
          borderRadius: BorderRadius.circular(20), // Bordes redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade50,
              blurRadius: 20, // Suavidad de la sombra
              offset: Offset(0, 8), // Posición de la sombra
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade300, // Color del borde
            width: 1, // Ancho del borde
          ),
        ),
        padding: const EdgeInsets.all(20), // Espaciado interno
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 470),
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 60, right: 60),
                    child: ApplicationLogo(),
                  ),
                  _body(),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _body() {
    return Column(
      children: [
        SizedBox(height: 36),
        Text(
          'Recuperar senha',
          style: TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 24),
        ),
        SizedBox(height: 16),
        Text(
          'Digite o e-mail associado à sua conta e enviaremos um e-mail para alterar sua senha',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 26),
        _form(),
      ],
    );
  }

  Widget _form() {
    return Column(
      children: [
        Input(
          label: "E-mail",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            // authStore.setEmail(value);
            // _validateForm();
          },
        ),
        SizedBox(height: 60),
        CustomButton(
            text: "Enviar",
            backgroundColor: AppColors.green,
            onPressed: () => {}),
      ],
    );
  }
}
