import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../theme/app_color.dart';
import '../theme/app_fonts.dart';
import '../utils/app_localizations_ext.dart';

class Input extends StatefulWidget {
  final String label;
  final String? Function(String?)? onValidator;
  final Function(String) onChanged;
  final dynamic? initialValue;
  final Widget? labelSuffix;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final bool? isPass;
  final Icon? iconRight;
  final IconData? icon;
  final GestureTapCallback? onIconTap;
  final int maxLines;
  final bool readOnly;

  const Input({
    super.key,
    this.onIconTap,
    this.icon,
    this.iconRight,
    this.isPass = false,
    required this.label,
    this.labelSuffix,
    required this.onChanged,
    this.onValidator,
    this.initialValue,
    this.keyboardType,
    this.inputFormatters,
    this.onTap,
    this.maxLines = 1,
    this.readOnly = false,
  });

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
      final updatedText = widget.initialValue?.toString() ?? '';

      if (_controller.text != updatedText) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _controller.value = _controller.value.copyWith(
            text: updatedText,
            selection: TextSelection.collapsed(offset: updatedText.length),
            composing: TextRange.empty,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._generateLabel(widget.label, suffix: widget.labelSuffix),
          TextFormField(
            controller: _controller,
            obscureText: widget.isPass ?? false,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: _inputDecoration(
              widget.icon,
              widget.iconRight,
              widget.onIconTap,
            ),
            validator: widget.onValidator,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            readOnly: widget.readOnly,
            maxLines: widget.isPass == true ? 1 : widget.maxLines,
            style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
        ],
      ),
    );
  }
}

List<Widget> _generateLabel(String label, {Widget? suffix}) {
  return [
    Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.purple,
            fontFamily: AppFonts.fontTitle,
            fontSize: 15,
          ),
        ),
        if (suffix != null) ...[const SizedBox(width: 6), suffix],
      ],
    ),
    const SizedBox(height: 8),
  ];
}

InputDecoration _inputDecoration(
  IconData? icon,
  Icon? iconRight,
  GestureTapCallback? onIconTap,
) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(16),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(
        Radius.circular(18),
      ), // Modify error border color
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    prefixIcon: icon != null ? Icon(icon, color: AppColors.greyMiddle) : null,
    // Modify prefix icon color
    suffixIcon:
        iconRight != null
            ? GestureDetector(onTap: onIconTap ?? () {}, child: iconRight)
            : null,
    hintStyle: const TextStyle(
      color: AppColors.greyMiddle,
      fontFamily: AppFonts.fontSubTitle,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.greyMiddle),
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.greyMiddle),
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
  );
}

class Dropdown extends StatefulWidget {
  final List<String> items;
  final String label;
  final String? Function(String?)? onValidator;
  final Function(String) onChanged;
  final Widget? labelSuffix;
  final String? initialValue;
  final String searchHint;

  const Dropdown({
    Key? key,
    required this.items,
    required this.label,
    this.onValidator,
    required this.onChanged,
    this.labelSuffix,
    this.initialValue,
    this.searchHint = 'Buscar...',
  }) : super(key: key);

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _dropdownFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  String? _selectedValue;
  List<String> _filteredItems = [];
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  ModalRoute? _route;
  bool _isDisposing = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _filteredItems = List.from(widget.items);

    // Solo cerramos cuando el dropdown pierde el foco
    // y el campo de búsqueda también lo ha perdido
    _dropdownFocusNode.addListener(() {
      if (!_dropdownFocusNode.hasFocus &&
          !_searchFocusNode.hasFocus &&
          _isDropdownOpen) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!_searchFocusNode.hasFocus) {
            _closeDropdown();
          }
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Guardar referencia segura al ModalRoute
    _route = ModalRoute.of(context);
  }

  @override
  void didUpdateWidget(Dropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedValue = widget.initialValue;
    }
    if (widget.items != oldWidget.items) {
      _filteredItems = List.from(widget.items);
    }
  }

  @override
  void dispose() {
    // Marcar que estamos en proceso de disposición
    _isDisposing = true;

    // Primero eliminar el overlay de manera segura
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    // Establecer variable directamente sin setState
    _isDropdownOpen = false;

    // Luego disponer de los controladores
    _searchController.dispose();
    _dropdownFocusNode.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _dropdownFocusNode.requestFocus();
    final RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 5),
              showWhenUnlinked: false,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: size.width,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 350,
                      minWidth: size.width,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.greyMiddle),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Campo de búsqueda
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              hintText:
                                  widget.searchHint.isNotEmpty
                                      ? widget.searchHint
                                      : context.l10n.common_search_hint,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onChanged: _filterItems,
                          ),
                        ),
                        // Lista de resultados
                        Flexible(
                          child:
                              _filteredItems.isEmpty
                                  ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        context.l10n.common_no_results_found,
                                      ),
                                    ),
                                  )
                                  : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: _filteredItems.length,
                                    itemBuilder: (context, index) {
                                      final item = _filteredItems[index];
                                      return ListTile(
                                        dense: true,
                                        title: Text(
                                          item,
                                          style: TextStyle(
                                            fontFamily: AppFonts.fontSubTitle,
                                            color:
                                                item == _selectedValue
                                                    ? AppColors.purple
                                                    : Colors.black87,
                                          ),
                                        ),
                                        onTap: () => _selectItem(item),
                                      );
                                    },
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    final overlayState = Overlay.of(context, rootOverlay: true);
    if (overlayState == null) return;
    overlayState.insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });

    // Enfocamos el campo de búsqueda después de crear el overlay
    Future.delayed(const Duration(milliseconds: 50), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _closeDropdown() {
    // Verificar si estamos en proceso de disposición o si el widget no está montado
    if (_isDisposing || !mounted) return;

    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    if (_searchController.hasListeners) {
      _searchController.clear();
    }

    _filteredItems = List.from(widget.items);

    setState(() {
      _isDropdownOpen = false;
    });
  }

  void _filterItems(String query) {
    // No actualizar si estamos en proceso de disposición
    if (_isDisposing) return;

    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        _filteredItems =
            widget.items
                .where(
                  (item) => item.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });

    // Actualizar el overlay para reflejar los resultados filtrados
    _overlayEntry?.markNeedsBuild();
  }

  void _selectItem(String value) {
    // No actualizar si estamos en proceso de disposición
    if (_isDisposing) return;

    setState(() {
      _selectedValue = value;
    });
    widget.onChanged(value);
    _closeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._generateLabel(widget.label, suffix: widget.labelSuffix),
          FormField<String>(
            initialValue: _selectedValue,
            validator: widget.onValidator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (FormFieldState<String> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo seleccionable que muestra el valor actual
                  GestureDetector(
                    onTap: _toggleDropdown,
                    child: Container(
                      child: CompositedTransformTarget(
                        link: _layerLink,
                        child: Container(
                          key: _dropdownKey,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  state.hasError
                                      ? Colors.red
                                      : AppColors.greyMiddle,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedValue ?? '',
                                  style: TextStyle(
                                    fontFamily: AppFonts.fontSubTitle,
                                    color:
                                        _selectedValue == null
                                            ? AppColors.greyMiddle
                                            : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                _isDropdownOpen
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: AppColors.greyMiddle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Mensaje de error
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 12),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  // Campo invisible para manejar el foco principal
                  Offstage(
                    child: Focus(
                      focusNode: _dropdownFocusNode,
                      child: Container(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class MoneyInput extends TextInputFormatter {
  final NumberFormat format;

  MoneyInput(this.format);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r"\D"), "");
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: "");
    }
    final value = double.parse(digitsOnly) / 100;
    final newText = format.format(value);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
