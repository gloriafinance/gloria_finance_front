import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

import '../../models/member_model.dart';
import 'member_detail_support.dart';

class MemberProfileSummaryCard extends StatelessWidget {
  final MemberModel member;
  final bool mobile;
  final Widget statusBadge;
  final String photoUnavailableLabel;

  const MemberProfileSummaryCard({
    super.key,
    required this.member,
    required this.mobile,
    required this.statusBadge,
    required this.photoUnavailableLabel,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl = memberDetailPhotoUrl(member);
    final photoSize = mobile ? 140.0 : 190.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment:
            mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: photoSize,
              height: photoSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.greyLight,
              ),
              clipBehavior: Clip.antiAlias,
              child:
                  photoUrl != null
                      ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _photoPlaceholder(photoSize),
                      )
                      : _photoPlaceholder(photoSize),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            member.name,
            textAlign: mobile ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          _identityLine(member.phone, Icons.phone_outlined),
          if (member.email.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _identityLine(member.email, Icons.mail_outline),
          ],
          const SizedBox(height: 18),
          Align(
            alignment: mobile ? Alignment.center : Alignment.centerLeft,
            child: statusBadge,
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder(double size) {
    return Container(
      color: AppColors.greyLight,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: size * 0.34, color: Colors.black45),
          const SizedBox(height: 10),
          Text(
            photoUnavailableLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: mobile ? 12 : 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _identityLine(String value, IconData icon) {
    return Row(
      mainAxisAlignment:
          mobile ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.grey),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: mobile ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 14,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
