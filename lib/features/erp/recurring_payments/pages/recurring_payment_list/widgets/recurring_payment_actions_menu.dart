import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';

import '../../../models/recurring_payment_model.dart';

/// Menú de acciones secundarias de una recurrencia.
///
/// Solo trae lo que existe hoy en el dominio: reutilizar el destino PIX. No hay
/// "eliminar" porque la API no expone borrado; el ciclo de vida es activar/desactivar.
class RecurringPaymentActionsMenu extends StatelessWidget {
  const RecurringPaymentActionsMenu({super.key, required this.payment});

  final RecurringPaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final hasPix = payment.hasPixDestination;

    return PopupMenuButton<String>(
      tooltip: context.l10n.recurringPayments_more_actions,
      offset: const Offset(0, 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: Icon(
        Icons.more_vert,
        size: isMobile(context) ? 20 : 22,
        color: AppColors.grey,
      ),
      itemBuilder:
          (menuContext) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'copy_pix_key',
              enabled: hasPix,
              child: Row(
                children: [
                  Icon(
                    Icons.copy_outlined,
                    size: 18,
                    color: hasPix ? AppColors.purple : AppColors.greyMiddle,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.l10n.recurringPayments_menu_copy_pix_key,
                    style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
                  ),
                ],
              ),
            ),
          ],
      onSelected: (value) {
        if (value == 'copy_pix_key') {
          _copyPixKey(context);
        }
      },
    );
  }

  Future<void> _copyPixKey(BuildContext context) async {
    final pixKey = payment.pixDestination?.pixKey ?? '';
    if (pixKey.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: pixKey));

    if (!context.mounted) return;
    Toast.showMessage(
      context.l10n.recurringPayments_pix_key_copied,
      ToastType.info,
    );
  }
}
