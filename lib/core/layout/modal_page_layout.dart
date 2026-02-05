import 'package:gloria_finance/core/utils/index.dart';
import 'package:flutter/material.dart';

import '../theme/app_fonts.dart';

class ModalPage {
  final String title;
  final Widget body;
  final double width;
  final List<Widget>? actions;

  const ModalPage({
    required this.title,
    required this.body,
    this.width = 750.0,
    this.actions,
  });

  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return _modal(context);
      },
    );
  }

  Widget _modal(BuildContext context) {
    return Dialog(
      //backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        width: isMobile(context) ? MediaQuery.of(context).size.width : width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título con botones de acción y botón "X" para cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: AppFonts.fontTitle,
                      ),
                    ),
                  ),
                  if (actions != null) ...[
                    ...actions!,
                    const SizedBox(width: 8),
                  ],
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el modal
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Contenido del cuerpo del modal
              body,
            ],
          ),
        ),
      ),
    );
  }
}
