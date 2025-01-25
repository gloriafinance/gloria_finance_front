import 'package:flutter/material.dart';

class ApplicationLogo extends StatelessWidget {
  final double? width;

  const ApplicationLogo({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/logo.png',
      width: width,
      //height: 70,
    );
  }
}
