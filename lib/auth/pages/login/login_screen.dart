import 'package:church_finance_bk/auth/widgets/layout_auth.dart';
import 'package:church_finance_bk/core/widgets/app_logo.dart';
import 'package:flutter/material.dart';

import 'widgets/form_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              shrinkWrap: true, // Ajusta la lista al contenido
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 60, right: 60),
                      child: ApplicationLogo(),
                    ),
                    const FormLogin()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _LoginScreenState extends State<LoginScreen> {
//   String _version = 'Carregando...';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadVersion();
//   }
//
//   Future<void> _loadVersion() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     setState(() {
//       _version = 'v${packageInfo.version}+${packageInfo.buildNumber}';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Toast.init(context);
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           const BackgroundContainer(),
//           Center(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white, // Color de fondo del contenedor
//                 borderRadius: BorderRadius.circular(20), // Bordes redondeados
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade50,
//                     blurRadius: 20, // Suavidad de la sombra
//                     offset: Offset(0, 8), // Posición de la sombra
//                   ),
//                 ],
//                 border: Border.all(
//                   color: Colors.grey.shade300, // Color del borde
//                   width: 1, // Ancho del borde
//                 ),
//               ),
//               padding: const EdgeInsets.all(20), // Espaciado interno
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 470),
//                 child: ListView(
//                   shrinkWrap: true, // Ajusta la lista al contenido
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.only(left: 60, right: 60),
//                           child: ApplicationLogo(),
//                         ),
//                         const FormLogin()
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: Text(
//                 textAlign: TextAlign.center,
//                 '© ${DateTime.now().year} Jaspesoft CNPJ 43.716.343/0001-60 ${_version}',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontFamily: AppFonts.fontSubTitle,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
