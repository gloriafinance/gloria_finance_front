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
  final EdgeInsetsGeometry? padding;
  final Color? disabledBackgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    this.textColor = Colors.black87,
    this.typeButton = 'basic',
    this.icon,
    this.leading,
    this.padding,
    this.disabledBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: typeButton == 'basic' ? _basicStyle() : _outlineStyle(),
      onPressed: onPressed,
      child: Padding(
        padding:
            padding ??
            (isMobile(context)
                ? const EdgeInsets.only(top: 18, bottom: 18)
                : const EdgeInsets.only(top: 14, bottom: 14)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canFlex = constraints.maxWidth.isFinite;
            final textWidget = Text(
              text.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                color: textColor,
                fontSize: 14.0,
              ),
            );

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) leading!,
                if (leading != null) const SizedBox(width: 14),
                if (leading == null && icon != null)
                  Icon(
                    icon,
                    color: textColor, // Color del icono
                  ),
                if (leading == null && icon != null) const SizedBox(width: 14),
                if (canFlex) Flexible(fit: FlexFit.loose, child: textWidget),
                if (!canFlex) textWidget,
              ],
            );
          },
        ),
      ),
    );
  }

  ButtonStyle _basicStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor:
          disabledBackgroundColor == null
              ? null
              : textColor.withValues(alpha: 0.55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      side: BorderSide.none,
      elevation: 1.0,
      shadowColor: Colors.black26,
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
