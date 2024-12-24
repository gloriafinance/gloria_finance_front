import 'package:flutter/material.dart';

class IPUBLogo extends StatelessWidget {
  final double? width;

  const IPUBLogo({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/ipub_logo.png',
      width: width,
    );
  }
}
