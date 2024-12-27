import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomSelect extends StatefulWidget {
  final String label;
  final String formControlName;

  //final List<DropdownMenuItem> items;
  final List<String> items;

  const CustomSelect(
      {super.key,
      required this.label,
      required this.formControlName,
      required this.items});

  @override
  State<CustomSelect> createState() => _CustomSelect();
}

class _CustomSelect extends State<CustomSelect> {
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
          ReactiveDropdownField(
            formControlName: widget.formControlName,
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(
                      Radius.circular(24)) // Modify error border color
                  ),
              focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              hintText: widget.label,
              //hintStyle: const TextStyle(color: AppColors.greyMiddle),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.greyMiddle),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.greyMiddle),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
            hint: Text(widget.label),
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
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
