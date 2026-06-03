import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

class MemberProfileHeroCard extends StatelessWidget {
  final String name;
  final String churchName;
  final String memberSinceLabel;
  final String changePhotoLabel;
  final String photoHintLabel;
  final String? photoUrl;
  final Uint8List? previewPhotoBytes;
  final bool isLoading;
  final bool isUploadingPhoto;
  final VoidCallback onChangePhoto;

  const MemberProfileHeroCard({
    super.key,
    required this.name,
    required this.churchName,
    required this.memberSinceLabel,
    required this.changePhotoLabel,
    required this.photoHintLabel,
    required this.photoUrl,
    required this.previewPhotoBytes,
    required this.isLoading,
    required this.isUploadingPhoto,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _avatar(),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isUploadingPhoto ? null : onChangePhoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.purple.withValues(
                  alpha: 0.45,
                ),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon:
                  isUploadingPhoto
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Icon(Icons.photo_camera_outlined, size: 18),
              label: Text(
                changePhotoLabel,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            memberSinceLabel,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            churchName,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            photoHintLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    const double size = 168;
    final imageBytes = previewPhotoBytes;
    final imageUrl = _normalizedPhotoUrl(photoUrl);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF7B8FA1),
        border: Border.all(color: Colors.white, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child:
          imageBytes != null
              ? Image.memory(imageBytes, fit: BoxFit.cover)
              : imageUrl != null
              ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
              : _placeholder(),
    );
  }

  Widget _placeholder() {
    if (isLoading && photoUrl == null && previewPhotoBytes == null) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      );
    }

    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    return Container(
      color: const Color(0xFF7B8FA1),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontFamily: AppFonts.fontTitle,
          fontSize: 34,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String? _normalizedPhotoUrl(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return null;
    }

    return trimmed;
  }
}
