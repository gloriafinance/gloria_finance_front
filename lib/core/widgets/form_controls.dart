import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_color.dart';
import '../theme/app_fonts.dart';

class Input extends StatefulWidget {
  final String label;
  final String? Function(String?)? onValidator;
  final Function(String) onChanged;
  final dynamic? initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final bool? isPass;
  final Icon? iconRight;
  final IconData? icon;
  final GestureTapCallback? onIconTap;

  const Input(
      {super.key,
      this.onIconTap,
      this.icon,
      this.iconRight,
      this.isPass = false,
      required this.label,
      required this.onChanged,
      this.onValidator,
      this.initialValue,
      this.keyboardType,
      this.inputFormatters,
      this.onTap});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue?.toString());
  }

  @override
  void didUpdateWidget(covariant Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _controller.text = widget.initialValue?.toString() ?? '';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._generateLabel(widget.label),
          TextFormField(
            controller: _controller,
            obscureText: widget.isPass ?? false,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: _inputDecoration(
                widget.icon, widget.iconRight, widget.onIconTap),
            validator: widget.onValidator,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
        ],
      ),
    );
  }
}

List<Widget> _generateLabel(String label) {
  return [
    Text(label,
        style: const TextStyle(
            color: AppColors.purple,
            fontFamily: AppFonts.fontTitle,
            fontSize: 15)),
    const SizedBox(height: 8)
  ];
}

InputDecoration _inputDecoration(
    IconData? icon, Icon? iconRight, GestureTapCallback? onIconTap) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(16),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius:
            BorderRadius.all(Radius.circular(18)) // Modify error border color
        ),
    focusedErrorBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    prefixIcon: icon != null ? Icon(icon, color: AppColors.greyMiddle) : null,
    // Modify prefix icon color
    suffixIcon: iconRight != null
        ? GestureDetector(
            onTap: onIconTap ?? () {},
            child: iconRight,
          )
        : null,
    hintStyle: const TextStyle(
        color: AppColors.greyMiddle, fontFamily: AppFonts.fontSubTitle),
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.greyMiddle),
        borderRadius: BorderRadius.all(Radius.circular(18))),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.greyMiddle),
        borderRadius: BorderRadius.all(Radius.circular(18))),
  );
}

class Dropdown extends StatelessWidget {
  final List<String> items;
  final String label;
  final String? Function(String?)? onValidator;
  final Function(String) onChanged;

  const Dropdown(
      {super.key,
      required this.items,
      required this.label,
      this.onValidator,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ..._generateLabel(label),
        DropdownButtonFormField<String>(
          onChanged: (val) => onChanged(val!),
          validator: onValidator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: _inputDecoration(null, null, null),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
