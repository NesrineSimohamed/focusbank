import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CircularTimerWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String formattedTime;
  final String currentSubject;
  final bool isRunning;

  const CircularTimerWidget({
    super.key,
    required this.progress,
    required this.formattedTime,
    required this.currentSubject,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer subtle glow
          Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isRunning
                      ? AppTheme.primaryGold.withOpacity(0.18)
                      : Colors.transparent,
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),

          // Custom Painted Circular Track & Indicator
          CustomPaint(
            size: const Size(260, 260),
            painter: _TimerPainter(
              progress: progress,
              strokeWidth: 14.0,
              trackColor: AppTheme.surfaceBorder,
              progressColor: AppTheme.primaryGold,
            ),
          ),

          // Inner Content (Time & Subject)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Text(
                  currentSubject,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                formattedTime,
                style: const TextStyle(
                  color: AppTheme.textWhite,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isRunning ? Icons.hourglass_top : Icons.pause_circle_outline,
                    size: 14,
                    color: AppTheme.primaryGold,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isRunning ? 'Earning 1 FC / min' : 'Paused',
                    style: TextStyle(
                      color: isRunning ? AppTheme.goldLight : AppTheme.textDim,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  _TimerPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);
    // Start from top (-pi / 2)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor;
  }
}
