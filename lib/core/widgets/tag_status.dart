import 'package:flutter/material.dart';

import '../theme/app_fonts.dart';

Widget tagStatus(Color color, String textStatus) {
  return Container(
    padding: const EdgeInsets.all(5),
    width: double.infinity,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      textStatus,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: AppFonts.fontSubTitle,
      ),
    ),
  );
}
