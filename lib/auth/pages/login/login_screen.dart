import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/IPUBLogo.dart';
import 'package:church_finance_bk/core/widgets/background_container.dart';
import 'package:flutter/material.dart';

import 'widgets/form_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundContainer(),
          Center(
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
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  shrinkWrap: true, // Ajusta la lista al contenido
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 150, right: 150),
                          child: IPUBLogo(
                            width: 240,
                          ),
                        ),
                        const Text(
                          "Bem-vindo",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppFonts.fontMedium,
                          ),
                        ),
                        const FormLogin()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
