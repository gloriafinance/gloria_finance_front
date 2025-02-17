import 'package:flutter/material.dart';

class ApplicationLogo extends StatelessWidget {
  final double? height;

  const ApplicationLogo({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/logo.png',
      //width: width,
      height: height,
    );
  }
}
