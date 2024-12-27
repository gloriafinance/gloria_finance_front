import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.purple, Colors.deepPurpleAccent],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          stops: [0.3, 2.0],
        ),
      ),
      child: ClipPath(
        clipper: WaveClipper(),
        child: Container(
          color: Colors.grey.shade100, // Cambiado a un gris claro
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Dibujar una serie de olas en la parte superior de la pantalla
    path.moveTo(
        0,
        size.height *
            0.1); // Ajusta el valor y para cambiar la posición vertical inicial
    path.quadraticBezierTo(
      0,
      size.height * 0.08,
      0,
      size.height * 0.2,
    );
    path.quadraticBezierTo(
      size.width * 0.65,
      0,
      size.width * 2,
      size.height * 0.75,
    );
    path.lineTo(
        0,
        size.height *
            1); // Ajusta el valor y para cambiar la posición vertical final
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
