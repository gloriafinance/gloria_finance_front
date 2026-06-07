import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:go_router/go_router.dart';

class MemberContributeResultScreen extends StatelessWidget {
  final bool success;
  final MemberContributionType? type;
  final double? amount;
  final DateTime? paidAt;
  final String? errorMessage;

  const MemberContributeResultScreen({
    super.key,
    required this.success,
    this.type,
    this.amount,
    this.paidAt,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 18),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: success ? _SuccessCard() : _ErrorCard(message: errorMessage),
          ),
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8E5EF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 176,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned.fill(
                  child: CustomPaint(painter: _ConfettiPainter()),
                ),
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.green.withValues(alpha: 0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 60),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.member_contribution_result_sent_title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 25,
              color: AppColors.purple,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.member_contribution_result_receipt_received,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 15,
              color: AppColors.purple,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 33),
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFFD8D4E2))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.favorite, color: AppColors.purple, size: 29),
              ),
              const Expanded(child: Divider(color: Color(0xFFD8D4E2))),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            l10n.member_contribution_result_blessing_title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              color: AppColors.purple,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            l10n.member_contribution_result_blessing_subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 15,
              color: Color(0xFF7B68A6),
            ),
          ),
          const SizedBox(height: 36),
          _HomeButton(
            text: l10n.member_contribution_back_to_home,
            onPressed: () => context.go('/dashboard'),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String? message;

  const _ErrorCard({this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8E5EF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 56,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.member_contribution_result_error_title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: AppColors.purple,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message ?? l10n.member_contribution_result_error_message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 15,
              color: Color(0xFF7B68A6),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 32),
          _HomeButton(
            text: l10n.member_contribution_try_again,
            onPressed: () => context.go('/member/contribute/new'),
          ),
        ],
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _HomeButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_filled, color: Colors.white, size: 26),
            const SizedBox(width: 13),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final shapes = <_ConfettiShape>[
      _ConfettiShape(-126, -58, const Color(0xFFB79DE9), 22, 7, -0.72),
      _ConfettiShape(-88, -80, const Color(0xFFF7C75E), 8, 8, 0.2),
      _ConfettiShape(-125, 38, const Color(0xFF91D8A7), 9, 9, 0.0),
      _ConfettiShape(-92, 62, const Color(0xFFF7C75E), 15, 15, 0.75),
      _ConfettiShape(-42, -99, const Color(0xFFB79DE9), 11, 11, 0.14),
      _ConfettiShape(82, -103, const Color(0xFFF7C75E), 7, 7, 0.0),
      _ConfettiShape(127, -57, const Color(0xFF99DBAE), 11, 11, 0.0),
      _ConfettiShape(104, -87, const Color(0xFFB79DE9), 24, 8, -0.78),
      _ConfettiShape(103, 34, const Color(0xFFB79DE9), 6, 6, 0.0),
      _ConfettiShape(126, 34, const Color(0xFFB79DE9), 9, 9, 0.0),
      _ConfettiShape(80, 74, const Color(0xFFAFA9C8), 6, 6, 0.0),
    ];

    for (final shape in shapes) {
      paint.color = shape.color;
      final offset = center + Offset(shape.dx, shape.dy);
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(shape.rotation);
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: shape.width,
        height: shape.height,
      );
      if (shape.width == shape.height && shape.width <= 9) {
        canvas.drawCircle(Offset.zero, shape.width / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(3)),
          paint,
        );
      }
      canvas.restore();
    }

    paint.color = const Color(0xFFF7C75E);
    _drawSparkle(canvas, paint, center + const Offset(106, -12), 16);
  }

  void _drawSparkle(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = -math.pi / 2 + i * math.pi / 4;
      final r = i.isEven ? radius : radius * 0.34;
      final point = Offset(
        center.dx + math.cos(angle) * r,
        center.dy + math.sin(angle) * r,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConfettiShape {
  final double dx;
  final double dy;
  final Color color;
  final double width;
  final double height;
  final double rotation;

  const _ConfettiShape(
    this.dx,
    this.dy,
    this.color,
    this.width,
    this.height,
    this.rotation,
  );
}
