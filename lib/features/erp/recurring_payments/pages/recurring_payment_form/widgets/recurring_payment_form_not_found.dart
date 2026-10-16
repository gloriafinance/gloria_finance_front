import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

/// La URL de edición apunta a una recorrência que no existe (link viejo o
/// registro borrado).
///
/// Sin esto el formulario se veía vacío como si fuera una creación y al guardar
/// hacía un POST: se creaba una recorrência nueva desde una ruta de edición.
class RecurringPaymentFormNotFound extends StatelessWidget {
  const RecurringPaymentFormNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.search_off,
              size: 30,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.recurringPayments_not_found_title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.recurringPayments_not_found_description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 13.5,
              height: 1.7,
              color: Color(0xFF5F5F5F),
            ),
          ),
          const SizedBox(height: 22),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: CustomButton(
              text: context.l10n.recurringPayments_back_to_list_action,
              backgroundColor: AppColors.purple,
              textColor: Colors.white,
              icon: Icons.arrow_back,
              onPressed: () => context.go('/recurring-payments/configuration'),
            ),
          ),
        ],
      ),
    );
  }
}
