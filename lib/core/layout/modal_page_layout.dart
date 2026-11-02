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
  final double headerSpacing;
  final bool useDialog;
  final bool scrollable;
  final bool expand;
  final Color? backgroundColor;

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
    this.headerSpacing = 16,
    this.useDialog = true,
    this.scrollable = true,
    this.expand = false,
    this.backgroundColor,
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
    final content = Container(
      padding: contentPadding,
      width: isMobile(context) ? MediaQuery.of(context).size.width : width,
      decoration:
          useDialog
              ? null
              : BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
      child: scrollable ? SingleChildScrollView(child: _content()) : _content(),
    );

    if (!useDialog) return content;

    return Dialog(
      backgroundColor: backgroundColor,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: content,
    );
  }

  Widget _content() {
    return Column(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
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
                if (actions != null) ...[...actions!, const SizedBox(width: 8)],
                Builder(
                  builder:
                      (context) => IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                ),
              ],
            ),
        SizedBox(height: headerSpacing),
        if (expand) Expanded(child: body) else body,
      ],
    );
  }
}
