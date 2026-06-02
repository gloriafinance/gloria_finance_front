import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/utils/app_localizations_ext.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/form_controls.dart';
import '../../../core/widgets/loading.dart';
import '../store/member_registration_store.dart';
import '../validators/member_registration_validator.dart';

class MemberRegistrationScreen extends StatefulWidget {
  final String token;

  const MemberRegistrationScreen({super.key, required this.token});

  @override
  State<MemberRegistrationScreen> createState() =>
      _MemberRegistrationScreenState();
}

class _MemberRegistrationScreenState extends State<MemberRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  Uint8List? _photoBytes;
  String? _photoName;
  String? _photoMimeType;

  static const Color _bgColor = Color(0xFFF5F5F7);
  static const Color _textDark = Color(0xFF333333);
  static const Color _textMuted = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemberRegistrationStore>().loadChurchInfo(widget.token);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      if (bytes.length > 3 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.member_registration_photo_too_large),
            ),
          );
        }
        return;
      }

      final mimeType = _inferMimeType(picked.name);

      setState(() {
        _photoBytes = bytes;
        _photoName = picked.name;
        _photoMimeType = mimeType;
      });
    } catch (e) {
      // Ignore
    }
  }

  String _inferMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  void _submit(MemberRegistrationStore store) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_photoBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.member_registration_photo_required),
        ),
      );
      return;
    }

    final success = await store.submit(
      widget.token,
      _photoBytes!,
      _photoName ?? 'photo.jpg',
      _photoMimeType ?? 'image/jpeg',
    );
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.member_registration_submit_error),
        ),
      );
    }
  }

  bool get _isWide {
    return MediaQuery.of(context).size.width >= 640;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final store = context.watch<MemberRegistrationStore>();

    if (store.loading && store.churchInfo == null) {
      return const Scaffold(
        backgroundColor: _bgColor,
        body: Center(child: Loading()),
      );
    }

    if (store.error == 'token_invalid') {
      return Scaffold(
        backgroundColor: _bgColor,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ApplicationLogo(height: 80),
                  const SizedBox(height: 24),
                  Text(
                    l10n.member_registration_invalid_token,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 18,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (store.submitted) {
      return Scaffold(
        backgroundColor: _bgColor,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ApplicationLogo(height: 80),
                  const SizedBox(height: 24),
                  Text(
                    l10n.member_registration_success_title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 22,
                      color: AppColors.purple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.member_registration_success_message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 16,
                      color: _textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final validator = MemberRegistrationValidator(
      requiredFullNameMessage: l10n.member_registration_full_name_required,
      requiredPhoneMessage: l10n.member_registration_phone_required,
      requiredLgpdMessage: l10n.member_registration_lgpd_required,
      invalidEmailMessage: l10n.member_registration_email_invalid,
    );

    final churchName = store.churchInfo?.churchName ?? '';

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: _isWide ? 24 : 16,
                  vertical: _isWide ? 48 : 24,
                ),
                children: [
                  _buildHeader(l10n, churchName),
                  const SizedBox(height: 24),
                  _buildCard(l10n, store, validator),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, String churchName) {
    return Column(
      children: [
        const Center(child: ApplicationLogo(height: 72)),
        const SizedBox(height: 16),
        if (churchName.isNotEmpty)
          Text(
            churchName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              color: _textDark,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          l10n.member_registration_title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 26,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.member_registration_description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 15,
            color: _textMuted,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
    AppLocalizations l10n,
    MemberRegistrationStore store,
    MemberRegistrationValidator validator,
  ) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(_isWide ? 32 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhotoSection(l10n),
            const SizedBox(height: 16),
            _buildFullName(l10n, store, validator),
            _buildRow([
              _buildPhone(l10n, store, validator),
              _buildEmail(l10n, store, validator),
            ]),
            _buildRow([
              _buildDni(l10n, store),
              _buildBirthdate(l10n, store),
            ]),
            _buildGender(l10n, store),
            const SizedBox(height: 8),
            _buildAddressExpansion(l10n, store),
            const SizedBox(height: 24),
            _buildLgpdCheckbox(l10n, store),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: store.formState.makeRequest
                  ? const Loading()
                  : CustomButton(
                      backgroundColor: AppColors.green,
                      text: l10n.member_registration_submit,
                      onPressed: () => _submit(store),
                      typeButton: CustomButton.basic,
                      textColor: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(AppLocalizations l10n) {
    return Center(
      child: Column(
        children: [
          if (_photoBytes != null)
            CircleAvatar(
              radius: _isWide ? 56 : 48,
              backgroundImage: MemoryImage(_photoBytes!),
            )
          else
            CircleAvatar(
              radius: _isWide ? 56 : 48,
              backgroundColor: const Color(0xFFF3F4F6),
              child: Icon(
                Icons.camera_alt_outlined,
                size: _isWide ? 40 : 32,
                color: AppColors.grey,
              ),
            ),
          const SizedBox(height: 12),
          CustomButton(
            backgroundColor: AppColors.purple,
            text: _photoBytes == null
                ? l10n.member_registration_add_photo
                : l10n.member_registration_change_photo,
            onPressed: () => _pickImage(
              _photoBytes == null ? ImageSource.camera : ImageSource.gallery,
            ),
            typeButton: CustomButton.basic,
            textColor: Colors.white,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.member_registration_photo_hint,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: _textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullName(
    AppLocalizations l10n,
    MemberRegistrationStore store,
    MemberRegistrationValidator validator,
  ) {
    return Input(
      label: l10n.member_registration_full_name,
      icon: Icons.person_outline,
      onValidator: validator.byField(store.formState, 'fullName'),
      onChanged: store.setFullName,
    );
  }

  Widget _buildPhone(
    AppLocalizations l10n,
    MemberRegistrationStore store,
    MemberRegistrationValidator validator,
  ) {
    return Input(
      label: l10n.member_registration_phone,
      icon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      onValidator: validator.byField(store.formState, 'phone'),
      onChanged: store.setPhone,
    );
  }

  Widget _buildEmail(
    AppLocalizations l10n,
    MemberRegistrationStore store,
    MemberRegistrationValidator validator,
  ) {
    return Input(
      label: l10n.member_registration_email_optional,
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      onValidator: validator.byField(store.formState, 'email'),
      onChanged: store.setEmail,
    );
  }

  Widget _buildDni(
    AppLocalizations l10n,
    MemberRegistrationStore store,
  ) {
    return Input(
      label: l10n.member_registration_dni_optional,
      icon: Icons.badge_outlined,
      onChanged: store.setDni,
    );
  }

  Widget _buildBirthdate(
    AppLocalizations l10n,
    MemberRegistrationStore store,
  ) {
    return Input(
      label: l10n.member_registration_birthdate_optional,
      icon: Icons.calendar_today_outlined,
      readOnly: true,
      initialValue: store.formState.birthdate != null
          ? '${store.formState.birthdate!.day.toString().padLeft(2, '0')}/${store.formState.birthdate!.month.toString().padLeft(2, '0')}/${store.formState.birthdate!.year}'
          : '',
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(
            const Duration(days: 365 * 18),
          ),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          store.setBirthdate(picked);
        }
      },
      onChanged: (_) {},
    );
  }

  Widget _buildGender(
    AppLocalizations l10n,
    MemberRegistrationStore store,
  ) {
    return Dropdown(
      label: l10n.member_registration_gender_optional,
      items: [
        l10n.member_registration_gender_male,
        l10n.member_registration_gender_female,
        l10n.member_registration_gender_not_informed,
      ],
      onChanged: (value) => store.setGender(value),
      searchHint: l10n.common_search_hint,
    );
  }

  Widget _buildRow(List<Widget> children) {
    if (!_isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map(
            (child) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: child,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAddressExpansion(
    AppLocalizations l10n,
    MemberRegistrationStore store,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(
          l10n.member_registration_address_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 15,
            color: AppColors.purple,
          ),
        ),
        iconColor: AppColors.purple,
        collapsedIconColor: AppColors.purple,
        children: [
          _buildRow([
            _buildAddressInput(
              l10n.member_registration_address_zip_code,
              store.setAddressZipCode,
            ),
            _buildAddressInput(
              l10n.member_registration_address_street,
              store.setAddressStreet,
            ),
          ]),
          _buildRow([
            _buildAddressInput(
              l10n.member_registration_address_number,
              store.setAddressNumber,
            ),
            _buildAddressInput(
              l10n.member_registration_address_complement,
              store.setAddressComplement,
            ),
          ]),
          _buildRow([
            _buildAddressInput(
              l10n.member_registration_address_district,
              store.setAddressDistrict,
            ),
            _buildAddressInput(
              l10n.member_registration_address_city,
              store.setAddressCity,
            ),
          ]),
          _buildRow([
            _buildAddressInput(
              l10n.member_registration_address_state,
              store.setAddressState,
            ),
            const SizedBox.shrink(),
          ]),
        ],
      ),
    );
  }

  Widget _buildAddressInput(String label, void Function(String) onChanged) {
    return Input(
      label: label,
      onChanged: onChanged,
    );
  }

  Widget _buildLgpdCheckbox(
    AppLocalizations l10n,
    MemberRegistrationStore store,
  ) {
    return FormField<bool>(
      initialValue: store.formState.lgpdConsentAccepted,
      validator: (value) {
        if (value != true) {
          return l10n.member_registration_lgpd_required;
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: store.formState.lgpdConsentAccepted,
              onChanged: (v) => store.setLgpdConsent(v ?? false),
              title: Text(
                l10n.member_registration_lgpd_label,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 14,
                  color: _textDark,
                  height: 1.4,
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.green,
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
