import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';

import '../theme/app_fonts.dart';

class ModalPage {
  final String title;
  final Widget body;
  final double width;

  const ModalPage({
    required this.title,
    required this.body,
    this.width = 750.0,
  });

  Future<void> show(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return _modal(context);
        });
  }

  Widget _modal(BuildContext context) {
    return Dialog(
      //backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        width: isMobile(context) ? MediaQuery.of(context).size.width : width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título con botón "X" para cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: AppFonts.fontMedium,
                    ),
                  ),
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
