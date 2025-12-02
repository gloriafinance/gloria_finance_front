import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:flutter/material.dart';

class ContributionPaymentMethodCards extends StatelessWidget {
  final MemberPaymentChannel? selectedChannel;
  final ValueChanged<MemberPaymentChannel> onChannelSelected;
  final List<MemberPaymentChannel> enabledChannels;

  const ContributionPaymentMethodCards({
    super.key,
    required this.selectedChannel,
    required this.onChannelSelected,
    this.enabledChannels = const [
      MemberPaymentChannel.pix,
      MemberPaymentChannel.boleto,
      MemberPaymentChannel.externalWithReceipt,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Como você quer registrar o pagamento?',
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 16,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (enabledChannels.contains(MemberPaymentChannel.pix)) ...[
          _buildMethodCard(
            context,
            MemberPaymentChannel.pix,
            Icons.qr_code_2,
            'PIX',
          ),
          const SizedBox(height: 10),
        ],
        if (enabledChannels.contains(MemberPaymentChannel.boleto)) ...[
          _buildMethodCard(
            context,
            MemberPaymentChannel.boleto,
            Icons.receipt_long,
            'Gerar boleto para pagar depois',
          ),
          const SizedBox(height: 10),
        ],
        if (enabledChannels.contains(
          MemberPaymentChannel.externalWithReceipt,
        )) ...[
          _buildMethodCard(
            context,
            MemberPaymentChannel.externalWithReceipt,
            Icons.upload_file,
            'Já contribui, quero enviar o comprovante',
          ),
        ],
      ],
    );
  }

  Widget _buildMethodCard(
    BuildContext context,
    MemberPaymentChannel channel,
    IconData icon,
    String title,
  ) {
    final isSelected = selectedChannel == channel;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChannelSelected(channel),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.purple : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            color:
                isSelected
                    ? AppColors.purple.withValues(alpha: 0.05)
                    : Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.purple.withValues(alpha: 0.1)
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.purple : Colors.grey.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      channel.description,
                      style: TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.purple,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
