import 'package:flutter/material.dart';

import '../theme/index.dart';
import 'index.dart';

Future<bool?> confirmationDialog(BuildContext context, String message) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.deepOrange,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Atenção!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                      fontFamily: AppFonts.fontTitle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontFamily: AppFonts.fontText,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonActionTable(
                        text: "Cancelar",
                        color: Colors.black38,
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: Icons.close,
                      ),
                      const SizedBox(width: 12),
                      ButtonActionTable(
                        text: "Confirmar",
                        icon: Icons.check,
                        color: AppColors.blue,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
