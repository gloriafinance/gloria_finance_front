import 'package:flutter/material.dart';

class ApplicationLogoHorizontal extends StatelessWidget {
  final double? width;

  const ApplicationLogoHorizontal({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/logoHorizontal.png',
      width: width,
      //height: 70,
    );
  }
}
