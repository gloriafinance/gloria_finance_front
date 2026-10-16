import 'package:gloria_finance/core/utils/index.dart';
import 'package:flutter/material.dart';

import '../theme/app_fonts.dart';

class ModalPage extends StatelessWidget {
  final String title;
  final Widget body;
  final double width;
  final List<Widget>? actions;
  final Widget? header;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;
  final EdgeInsets insetPadding;

  const ModalPage({
    super.key,
    required this.title,
    required this.body,
    this.width = 750.0,
    this.actions,
    this.header,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 10,
    ),
    this.borderRadius = 16,
    this.insetPadding = const EdgeInsets.all(16),
  });

  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      //backgroundColor: Colors.white,
      insetPadding: insetPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        padding: contentPadding,
        width: isMobile(context) ? MediaQuery.of(context).size.width : width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              header ??
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
