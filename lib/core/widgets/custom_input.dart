import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

typedef StringValue = String Function(String);

class CustomInput extends StatefulWidget {
  final String? formControlName;
  final String label;
  final TextInputType inputType;
  final Icon? icon;
  final Icon? iconRigth;
  final bool? isPass;
  final Color? borderColor;
  final StringValue? onValidator;
  final String? initialValue;
  final bool? disable;
  final int? minLines;
  final int? maxLength;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? placeholder;
  final double? top;
  final bool? readOnly;
  final ValueChanged<dynamic>? onChanged;
  final NumberFormat? formatter;

  const CustomInput(
      {super.key,
      required this.label,
      required this.inputType,
      this.formControlName,
      this.icon,
      this.iconRigth,
      this.isPass = false,
      this.borderColor,
      this.onValidator,
      this.initialValue,
      this.disable = false,
      this.minLines,
      this.maxLength,
      this.onTap,
      this.controller,
      this.inputFormatters,
      this.placeholder,
      this.top,
      this.onChanged,
      this.readOnly = false,
      this.formatter});

  @override
  _CustomTextField createState() => _CustomTextField();
}

class _CustomTextField extends State<CustomInput> {
  final bool hasLabel = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      // color: Colors.white,
      // margin: EdgeInsets.only(top: (widgets.top == null) ? 20.0 : widgets.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasLabel) ...generateLabel(),
          (widget.formControlName != null) ? _reactiveTextField() : _textField()
        ],
      ),
    );
  }

  Widget _textField() {
    final controller = widget.controller ?? TextEditingController();

    return TextField(
      controller: controller,
      style: const TextStyle(fontFamily: AppFonts.fontLight),
      obscureText: widget.isPass ?? false,
      readOnly: widget.readOnly ?? true,
      decoration: _inputDecoration(),
      keyboardType: widget.inputType,
      onChanged: (value) {
        if (widget.formatter != null) {
          if (value.isEmpty) {
            // Si el campo está vacío, no formatear y limpiar el controlador
            controller.value = TextEditingValue(
              text: '',
              selection: TextSelection.collapsed(offset: 0),
            );

            // Llama al callback con un valor nulo si está definido
            if (widget.onChanged != null) {
              widget.onChanged!(null);
            }
            return;
          }

          // Obtener la posición actual del cursor
          final cursorPosition = controller.selection.baseOffset;

          // Formatear el valor numérico
          final numericValue =
              double.tryParse(value.replaceAll(',', '')) ?? 0.0;
          final formattedValue = widget.formatter!.format(numericValue);

          // Calcular la nueva posición del cursor
          final newCursorPosition =
              formattedValue.length - (value.length - cursorPosition);

          // Actualizar el controlador con el valor formateado
          controller.value = TextEditingValue(
            text: formattedValue,
            selection: TextSelection.collapsed(
              offset: newCursorPosition.clamp(0, formattedValue.length),
            ),
          );

          // Llamar al callback onChanged si está definido
          if (widget.onChanged != null) {
            widget.onChanged!(numericValue);
          }
        } else if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      inputFormatters: widget.inputType == TextInputType.number
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : widget.inputFormatters, // Usa otros formatters si están definidos
    );
  }

  Widget _reactiveTextField() {
    final controller = widget.controller ?? TextEditingController();

    return ReactiveTextField(
      controller: controller,
      style: const TextStyle(
        fontFamily: AppFonts.fontLight,
        fontSize: 16,
      ),
      keyboardType: widget.inputType,
      formControlName: widget.formControlName,
      obscureText: widget.isPass ?? false,
      readOnly: widget.readOnly ?? true,
      decoration: _inputDecoration(),
      inputFormatters: widget.inputType == TextInputType.number
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : widget.inputFormatters,
      onChanged: (control) {
        if (widget.formatter != null) {
          // Obtén el texto actual
          final rawValue = controller.text.replaceAll(',', '');
          final numericValue = double.tryParse(rawValue);

          if (numericValue != null) {
            // Formatea el número
            final formattedValue = widget.formatter!.format(numericValue);

            // Solo actualiza el texto del controlador si el formato es diferente
            if (controller.text != formattedValue) {
              final cursorPosition = controller.selection.baseOffset;
              final newCursorPosition =
                  cursorPosition + (formattedValue.length - rawValue.length);

              controller.value = TextEditingValue(
                text: formattedValue,
                selection: TextSelection.collapsed(
                  offset: newCursorPosition.clamp(0, formattedValue.length),
                ),
              );
            }

            // Actualiza el valor del FormControl
            control.value = numericValue;
          }
        }
      },
      validationMessages: {
        ValidationMessage.required: (error) =>
            "${widget.label.toUpperCase()} Este campo não pode estar vacío",
      },
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(16),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius:
              BorderRadius.all(Radius.circular(18)) // Modify error border color
          ),
      focusedErrorBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      suffixIcon: widget.iconRigth != null
          ? GestureDetector(
              onTap: widget.onTap ?? () {},
              child: widget.iconRigth,
            )
          : null,
      hintText: widget.placeholder,
      hintStyle: const TextStyle(
          color: AppColors.greyMiddle, fontFamily: AppFonts.fontRegular),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyMiddle),
          borderRadius: BorderRadius.all(Radius.circular(18))),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyMiddle),
          borderRadius: BorderRadius.all(Radius.circular(18))),
    );
  }

  List<Widget> generateLabel() {
    return [
      Text(widget.label,
          style: const TextStyle(
              color: AppColors.purple,
              fontFamily: AppFonts.fontRegular,
              fontSize: 18)),
      const SizedBox(height: 8)
    ];
  }
}
