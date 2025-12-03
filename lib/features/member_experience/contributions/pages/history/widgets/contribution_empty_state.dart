import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class ContributionEmptyState extends StatelessWidget {
  const ContributionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/contribution.png',
              width: 240,
              height: 240,
              fit: BoxFit.contain,
              // Opcional: tintar la imagen a gris si el PNG tiene transparencia
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 24),
            const Text(
              'Você ainda não possui contribuições',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Quando você realizar uma contribuição, ela aparecerá aqui.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
