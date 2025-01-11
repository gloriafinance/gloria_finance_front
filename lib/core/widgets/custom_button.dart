import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final String typeButton;
  final Color textColor;
  static const String outline = 'outline';
  static const String basic = 'basic';
  final void Function()? onPressed;
  final IconData? icon;

  const CustomButton(
      {super.key,
      required this.text,
      required this.backgroundColor,
      required this.onPressed,
      this.textColor = Colors.black87,
      this.typeButton = 'basic',
      this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: typeButton == 'basic' ? _basicStyle() : _outlineStyle(),
      onPressed: onPressed,
      child: Padding(
        padding: isMobile(context)
            ? const EdgeInsets.only(top: 0, bottom: 0)
            : const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido
          children: [
            if (icon != null) // Si hay un icono, lo muestra
              Icon(
                icon,
                color: textColor, // Color del icono
              ),
            if (icon != null) // Espacio entre el icono y el texto
              const SizedBox(width: 8),
            Text(
              text.toUpperCase(),
              style: TextStyle(
                fontFamily: AppFonts.fontRegular,
                color: textColor,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _basicStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      // elevation: 4.0,
    );
  }

  ButtonStyle _outlineStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
      side: BorderSide(color: backgroundColor, width: 1.0),
    );
  }
}
