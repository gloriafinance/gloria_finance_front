import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/auth/auth_session_model.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/member_experience/profile/store/member_profile_store.dart';
import 'package:gloria_finance/features/member_experience/profile/widgets/member_profile_hero_card.dart';
import 'package:gloria_finance/features/member_experience/widgets/member_header.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

class MemberProfileScreen extends StatefulWidget {
  const MemberProfileScreen({super.key});

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  static const _maxPhotoBytes = 3 * 1024 * 1024;

  final MemberProfileStore _profileStore = MemberProfileStore();
  final ImagePicker _picker = ImagePicker();

  Uint8List? _previewPhotoBytes;

  @override
  void dispose() {
    _profileStore.dispose();
    super.dispose();
  }

  Future<void> _refreshProfile() async {
    await _profileStore.loadProfile(refresh: true);
  }

  Future<void> _pickAndUploadPhoto(
    BuildContext context,
    ImageSource source,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final tooLargeLabel = context.l10n.member_registration_photo_too_large;
    final invalidFormatLabel = context.l10n.member_profile_photo_invalid_format;
    final successLabel = context.l10n.member_profile_photo_updated;
    final errorLabel = context.l10n.member_profile_photo_update_error;

    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );

      if (picked == null) {
        return;
      }

      final bytes = await picked.readAsBytes();
      if (bytes.length > _maxPhotoBytes) {
        if (!mounted) return;
        messenger.showSnackBar(SnackBar(content: Text(tooLargeLabel)));
        return;
      }

      final mimeType = _mimeTypeFor(picked.name, picked.mimeType);
      if (mimeType == null) {
        if (!mounted) return;
        messenger.showSnackBar(SnackBar(content: Text(invalidFormatLabel)));
        return;
      }

      if (!mounted) return;
      setState(() {
        _previewPhotoBytes = bytes;
      });

      final success = await _profileStore.updateProfilePhoto(
        photoBytes: bytes,
        fileName: picked.name,
        mimeType: mimeType,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _previewPhotoBytes = null;
      });

      if (success) {
        messenger.showSnackBar(SnackBar(content: Text(successLabel)));
      } else if (_profileStore.errorMessage != null) {
        messenger.showSnackBar(SnackBar(content: Text(errorLabel)));
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _previewPhotoBytes = null;
      });
      messenger.showSnackBar(SnackBar(content: Text(errorLabel)));
    }
  }

  Future<void> _showPhotoSourceSheet(BuildContext context) async {
    final title = context.l10n.member_profile_photo_source_title;
    final cameraLabel = context.l10n.member_profile_photo_source_camera;
    final galleryLabel = context.l10n.member_profile_photo_source_gallery;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(16),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 14),
                _PhotoSourceTile(
                  icon: Icons.photo_camera_outlined,
                  label: cameraLabel,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickAndUploadPhoto(context, ImageSource.camera);
                  },
                ),
                const SizedBox(height: 8),
                _PhotoSourceTile(
                  icon: Icons.photo_library_outlined,
                  label: galleryLabel,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickAndUploadPhoto(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _mimeTypeFor(String fileName, String? detectedMimeType) {
    const allowed = {'image/jpeg', 'image/png', 'image/webp'};
    if (detectedMimeType != null && allowed.contains(detectedMimeType)) {
      return detectedMimeType;
    }

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
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = context.watch<AuthSessionStore>().state.session;

    if (_profileStore.profile == null && !_profileStore.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _profileStore.loadProfile(refresh: true);
      });
    }

    return ChangeNotifierProvider.value(
      value: _profileStore,
      child: Builder(
        builder: (context) {
          final profileStore = context.watch<MemberProfileStore>();
          final profile = profileStore.profile;
          final name = profile?.name ?? session.name;
          final churchName = profile?.church?.name ?? session.churchName;
          final createdAt = profile?.createdAt ?? session.createdAt;
          final memberSince = _memberSince(createdAt);

          return Column(
            children: [
              MemberHeaderWidget(
                title: l10n.member_drawer_profile,
                onBack: () => context.pop(),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshProfile,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      MemberProfileHeroCard(
                        name: name,
                        churchName: churchName,
                        memberSinceLabel: l10n.member_profile_member_since(
                          memberSince,
                        ),
                        changePhotoLabel: l10n.member_registration_change_photo,
                        photoHintLabel: l10n.member_registration_photo_hint,
                        photoUrl: profile?.profilePhoto,
                        previewPhotoBytes: _previewPhotoBytes,
                        isLoading: profileStore.isLoading,
                        isUploadingPhoto: profileStore.isUploadingPhoto,
                        onChangePhoto: () => _showPhotoSourceSheet(context),
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: l10n.member_profile_personal_data_title,
                        child: _buildPersonalDataCard(
                          session,
                          profileStore,
                          l10n,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: l10n.member_profile_notifications_title,
                        child: _buildSettings(context, l10n),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _memberSince(String createdAtRaw) {
    try {
      if (createdAtRaw.isNotEmpty) {
        return DateTime.parse(createdAtRaw).year.toString();
      }
    } catch (_) {}
    return '2023';
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildPersonalDataCard(
    AuthSessionModel session,
    MemberProfileStore profileStore,
    AppLocalizations l10n,
  ) {
    final name = profileStore.profile?.name ?? session.name;
    final email = profileStore.profile?.email ?? session.email;
    final phone = profileStore.profile?.phone ?? '';
    final dni = profileStore.profile?.dni ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child:
          profileStore.isLoading
              ? const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              )
              : Column(
                children: [
                  _buildInfoRow(
                    l10n.member_profile_full_name_label,
                    name.isNotEmpty ? name : '-',
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildInfoRow(
                    l10n.member_profile_email_label,
                    email.isNotEmpty ? email : '-',
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildInfoRow(
                    l10n.member_profile_phone_label,
                    phone.isNotEmpty ? phone : '-',
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildInfoRow(
                    l10n.member_profile_dni_label,
                    dni.isNotEmpty ? dni : '-',
                  ),
                ],
              ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 16,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.go('/member/settings');
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.member_profile_notifications_settings_title,
                        style: TextStyle(
                          fontFamily: AppFonts.fontTitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.member_profile_notifications_settings_subtitle,
                        style: TextStyle(
                          fontFamily: AppFonts.fontText,
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoSourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PhotoSourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F5FB),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.purple),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 15,
                    color: AppColors.black,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
