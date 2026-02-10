import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/index.dart';
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
  final Widget? leading;
  EdgeInsetsGeometry? padding;

  CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    this.textColor = Colors.black87,
    this.typeButton = 'basic',
    this.icon,
    this.leading,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: typeButton == 'basic' ? _basicStyle() : _outlineStyle(),
      onPressed: onPressed,
      child: Padding(
        padding:
            padding ??=
                isMobile(context)
                    ? EdgeInsets.only(top: 18, bottom: 18)
                    : EdgeInsets.only(top: 14, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) leading!,
            if (leading != null) const SizedBox(width: 14),
            if (leading == null && icon != null)
              Icon(
                icon,
                color: textColor, // Color del icono
              ),
            if (leading == null && icon != null) const SizedBox(width: 14),
            Flexible(
              child: Text(
                text.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  color: textColor,
                  fontSize: 14.0,
                ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4.0,
    );
  }

  ButtonStyle _outlineStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4.0,
      side: BorderSide(color: backgroundColor, width: 1.0),
    );
  }
}
