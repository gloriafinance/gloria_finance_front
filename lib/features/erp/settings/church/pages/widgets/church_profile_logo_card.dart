import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../store/church_store.dart';
import 'church_profile_card.dart';

class ChurchProfileLogoCard extends StatelessWidget {
  const ChurchProfileLogoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final store = context.read<ChurchStore>();
    final church = context.watch<ChurchStore>().church;
    final logoUrl = church?.logoUrl;

    return ChurchProfileCard(
      title: l10n.settings_church_profile_logo_title,
      child: Center(
        child: Column(
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
                image:
                    logoUrl != null && logoUrl.isNotEmpty
                        ? DecorationImage(
                          image: NetworkImage(logoUrl),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child:
                  logoUrl == null || logoUrl.isEmpty
                      ? const Icon(Icons.church, size: 60, color: Colors.grey)
                      : null,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.settings_church_profile_logo_subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: l10n.settings_church_profile_upload_button,
                backgroundColor: AppColors.greyMiddle,
                typeButton: CustomButton.outline,
                textColor: Colors.black,
                onPressed: () async {
                  // Connect to store upload
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                    withData: true, // Important for web/some platforms
                  );

                  if (result != null) {
                    final file = result.files.first;
                    // Prepare MultipartFile
                    if (file.bytes != null) {
                      final multipartFile = MultipartFile.fromBytes(
                        file.bytes!,
                        filename: file.name,
                      );
                      store.uploadLogo(multipartFile);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
