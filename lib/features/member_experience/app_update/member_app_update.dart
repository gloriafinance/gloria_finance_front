import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:in_app_update/in_app_update.dart';

class MemberAppUpdate {
  static Future<void> check(BuildContext context) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress) {
        await InAppUpdate.performImmediateUpdate();
        return;
      }

      if (!context.mounted ||
          updateInfo.updateAvailability != UpdateAvailability.updateAvailable ||
          !updateInfo.immediateUpdateAllowed) {
        return;
      }

      final copy = _copyFor(Localizations.localeOf(context).languageCode);
      final shouldUpdate = await ModalPage(
        title: copy.title,
        width: 420,
        body: _UpdatePrompt(copy: copy),
      ).show<bool>(context);

      if (shouldUpdate == true) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (_) {
      // Update checks must never block the member experience.
    }
  }

  static _UpdateCopy _copyFor(String languageCode) {
    switch (languageCode) {
      case 'pt':
        return const _UpdateCopy(
          title: 'Nova versão disponível',
          message:
              'Há uma nova versão do Glória Finance disponível com melhorias e correções.',
          later: 'Depois',
          updateNow: 'Atualizar agora',
        );
      case 'es':
        return const _UpdateCopy(
          title: 'Nueva versión disponible',
          message:
              'Hay una nueva versión de Glória Finance disponible con mejoras y correcciones.',
          later: 'Después',
          updateNow: 'Actualizar ahora',
        );
      default:
        return const _UpdateCopy(
          title: 'New version available',
          message:
              'A new version of Glória Finance is available with improvements and fixes.',
          later: 'Later',
          updateNow: 'Update now',
        );
    }
  }
}

class _UpdatePrompt extends StatelessWidget {
  final _UpdateCopy copy;

  const _UpdatePrompt({required this.copy});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(copy.message),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonActionTable(
              text: copy.later,
              color: Colors.black38,
              icon: Icons.schedule,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ButtonActionTable(
              text: copy.updateNow,
              color: AppColors.purple,
              icon: Icons.system_update_alt,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ],
    );
  }
}

class _UpdateCopy {
  final String title;
  final String message;
  final String later;
  final String updateNow;

  const _UpdateCopy({
    required this.title,
    required this.message,
    required this.later,
    required this.updateNow,
  });
}
