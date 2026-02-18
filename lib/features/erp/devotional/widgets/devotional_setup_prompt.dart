import 'package:flutter/material.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';

class DevotionalSetupPrompt extends StatelessWidget {
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;

  const DevotionalSetupPrompt({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: mobile ? double.infinity : 250,
            child: CustomButton(
              text: actionLabel,
              icon: Icons.settings_outlined,
              backgroundColor: AppColors.purple,
              textColor: Colors.white,
              onPressed: onAction,
            ),
          ),
        ],
      ),
    );
  }
}
