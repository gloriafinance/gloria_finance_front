import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String? label;

  const Loading({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.green,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              label ?? "REALIZANDO REQUISIÇÃO",
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
