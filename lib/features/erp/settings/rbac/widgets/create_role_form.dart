import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';

class CreateRoleForm extends StatefulWidget {
  const CreateRoleForm({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  final void Function(String name, String? description) onSubmit;
  final VoidCallback onCancel;

  @override
  State<CreateRoleForm> createState() => _CreateRoleFormState();
}

class _CreateRoleFormState extends State<CreateRoleForm> {
  final _formKey = GlobalKey<FormState>();
  var _roleName = '';
  var _roleDescription = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Input(
              label: 'Nome do papel',
              icon: Icons.badge_outlined,
              onChanged: (value) {
                _roleName = value;
              },
              onValidator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe um nome válido';
                }
                return null;
              },
            ),
            Input(
              label: 'Descrição',
              icon: Icons.description_outlined,
              maxLines: 3,
              onChanged: (value) {
                _roleDescription = value;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: 'Cancelar',
                  backgroundColor: AppColors.purple,
                  typeButton: CustomButton.outline,
                  onPressed: widget.onCancel,
                ),
                const SizedBox(width: 12),
                CustomButton(
                  text: 'Criar',
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    final description =
        _roleDescription.trim().isEmpty ? null : _roleDescription.trim();
    widget.onSubmit(_roleName.trim(), description);
  }
}
