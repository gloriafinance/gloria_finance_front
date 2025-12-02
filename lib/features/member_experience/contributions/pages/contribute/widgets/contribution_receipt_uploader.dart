import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/date_formatter.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
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
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload file widget
        UploadFile(
          label: 'Envie o comprovante do pagamento',
          multipartFile: widget.onFileSelected,
        ),
        // Date picker using Input
        Input(
          label: 'Data do pagamento',
          initialValue:
              widget.paidAt != null ? _dateFormat.format(widget.paidAt!) : '',
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
          'Esse comprovante será analisado pela tesouraria da sua igreja. É obrigatório anexar.',
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
