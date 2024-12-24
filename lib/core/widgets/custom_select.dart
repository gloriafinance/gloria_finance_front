import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomSelect<T> extends StatefulWidget {
  final String label;
  final String formControlName;
  final List<DropdownMenuItem<T>> items;

  const CustomSelect(
      {super.key,
      required this.label,
      required this.formControlName,
      required this.items});

  @override
  State<CustomSelect<T>> createState() => _CustomSelect<T>();
}

class _CustomSelect<T> extends State<CustomSelect<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [...generateLabel()],
          ),
          ReactiveDropdownField<T>(
            formControlName: widget.formControlName,
            decoration: InputDecoration(
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(
                      Radius.circular(24)) // Modify error border color
                  ),
              focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              hintText: widget.label,
              hintStyle: const TextStyle(color: AppColors.greyMiddle),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.greyMiddle),
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.greyMiddle),
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            hint: Text(widget.label),
            items: widget.items,
          ),
        ],
      ),
    );
  }

  List<Widget> generateLabel() {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(widget.label,
            style: const TextStyle(
                fontSize: 18,
                color: AppColors.purple,
                fontFamily: AppFonts.fontRegular)),
      ),
      // const SizedBox(height: 14)
    ];
  }
}
