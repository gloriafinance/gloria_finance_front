import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final String typeButton;
  final double width;
  static const String outline = 'outline';
  static const String basic = 'basic';
  final void Function()? onPressed;

  const CustomButton(
      {super.key,
      required this.text,
      required this.backgroundColor,
      required this.onPressed,
      this.typeButton = 'basic',
      this.width = 200.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
          style: typeButton == 'basic' ? _basicStyle() : _outlineStyle(),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              text.toUpperCase(),
              style: const TextStyle(
                fontFamily: AppFonts.fontLight,
                color: AppColors.black,
                fontSize: 18.0,
              ),
            ),
          )),
    );
  }

  ButtonStyle _basicStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 4.0,
    );
  }

  ButtonStyle _outlineStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 4.0,
      side: BorderSide(color: backgroundColor, width: 1.0),
    );
  }
}
