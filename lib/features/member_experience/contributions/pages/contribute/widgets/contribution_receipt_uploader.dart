import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/upload_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContributionReceiptUploader extends StatefulWidget {
  final DateTime? paidAt;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<MultipartFile> onFileSelected;
  final VoidCallback? onFileRemoved;
  final String? fileName;

  const ContributionReceiptUploader({
    super.key,
    required this.paidAt,
    required this.onDateSelected,
    required this.onFileSelected,
    this.onFileRemoved,
    this.fileName,
  });

  @override
  State<ContributionReceiptUploader> createState() =>
      _ContributionReceiptUploaderState();
}

class _ContributionReceiptUploaderState
    extends State<ContributionReceiptUploader> {

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat('dd/MM/yyyy', localeTag);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload file widget
        UploadFile(
          label: l10n.member_contribution_receipt_label,
          multipartFile: widget.onFileSelected,
        ),
        // Date picker using Input
        Input(
          label: l10n.member_contribution_receipt_payment_date_label,
          initialValue:
              widget.paidAt != null ? dateFormat.format(widget.paidAt!) : '',
          onChanged: (_) {},
          // Required but not used
          onTap: () => _selectDate(context),
          onIconTap: () => _selectDate(context),
          readOnly: true,
          iconRight: const Icon(
            Icons.calendar_today_outlined,
            color: AppColors.greyMiddle,
          ),
          keyboardType: TextInputType.datetime,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.member_contribution_receipt_help_text,
          style: TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await selectDate(context);

    if (picked != null) {
      widget.onDateSelected(picked);
    }
  }
}
