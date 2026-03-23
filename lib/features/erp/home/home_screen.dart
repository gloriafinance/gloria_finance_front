import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/trends/widgets/trend_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/availability_account_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        _buildSupportCard(context),
        const SizedBox(height: 32),
        AvailabilityAccountCards(),
        const SizedBox(height: 40),
        const TrendWidget(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.erp_home_header_title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 900;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.18)),
      ),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _supportCardLead(),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => context.go('/support-assistant'),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(context.l10n.support_assistant_open_screen),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: _supportCardLead()),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => context.go('/support-assistant'),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(context.l10n.support_assistant_open_screen),
                ),
              ],
            ),
    );
  }

  Widget _supportCardLead() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.purple.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.support_agent,
            color: AppColors.purple,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.support_assistant_title,
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6),
              Text(
                context.l10n.support_assistant_header_compact,
                style: TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
