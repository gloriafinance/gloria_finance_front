import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';

class ButtonActionTable extends StatelessWidget {
  final Color color;
  final String text;
  final void Function() onPressed;
  final IconData icon;

  const ButtonActionTable({
    super.key,
    required this.color,
    required this.text,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 18,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: isMobile(context) == true ? 12 : 14,
            fontFamily: AppFonts.fontSubTitle,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: isMobile(context)
              ? const EdgeInsets.symmetric(vertical: 2, horizontal: 8)
              : const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        ).copyWith(
          iconColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.white;
            }
            return color;
          }),
          // Cambia el color de fondo al hacer hover
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return color;
            }
            return Colors.transparent;
          }),
          // Cambia el color del texto e ícono al hacer hover
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.white;
            }
            return color;
          }),
          // Cambia el color del borde al hacer hover
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return BorderSide(color: color);
            }
            return BorderSide(color: color);
          }),
        ),
      ),
    );
  }
}
