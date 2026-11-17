import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // Session State
  bool _isSessionActive = false;
  bool _isRunning = false;
  Timer? _ticker;

  final TextEditingController _sessionNameController = TextEditingController(
    text: 'Mobile Dev Revision',
  );

  int _selectedMinutes = 20; // 20m default matching the screenshot (20:00)
  int _remainingSeconds = 20 * 60;
  int _secondsElapsed = 0;
  bool _receiveNotifications = true;

  @override
  void dispose() {
    _ticker?.cancel();
    _sessionNameController.dispose();
    super.dispose();
  }

  void _startSession() {
    setState(() {
      _isSessionActive = true;
      _isRunning = true;
      _remainingSeconds = _selectedMinutes * 60;
      _secondsElapsed = 0;
    });

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _secondsElapsed++;
        });
      } else {
        _finishSession();
      }
    });
  }

  void _pauseSession() {
    setState(() => _isRunning = false);
    _ticker?.cancel();
  }

  void _resumeSession() {
    setState(() => _isRunning = true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _secondsElapsed++;
        });
      } else {
        _finishSession();
      }
    });
  }

  void _finishSession() {
    _ticker?.cancel();
    final minutesDone = (_secondsElapsed / 60).ceil();
    if (minutesDone > 0) {
      AppState.instance.recordFocusSession(
        subject: _sessionNameController.text.trim().isEmpty
            ? 'Deep Focus'
            : _sessionNameController.text.trim(),
        minutesCompleted: minutesDone,
      );
    }

    setState(() {
      _isSessionActive = false;
      _isRunning = false;
      _remainingSeconds = _selectedMinutes * 60;
      _secondsElapsed = 0;
    });

    _showCelebrationDialog(minutesDone);
  }

  void _showCelebrationDialog(int minutes) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.primaryGold),
        ),
        title: const Text(
          'Session Completed! 🎉',
          style: TextStyle(
            color: AppTheme.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'You focused for $minutes minutes.\nEarnings deposited into your vault!',
          style: const TextStyle(color: AppTheme.textMuted),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: Colors.black,
            ),
            child: const Text('Great!'),
          ),
        ],
      ),
    );
  }

  String _formatDigital(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: _isSessionActive ? _buildActiveScreen() : _buildSetupScreen(),
      ),
    );
  }

  // -------------------------------------------------------------
  // SCREEN 1: Setup Focus Session (Matching Image 2)
  // -------------------------------------------------------------
  Widget _buildSetupScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Focus session',
            style: TextStyle(
              color: AppTheme.textWhite,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),

          // Session Name input
          TextField(
            controller: _sessionNameController,
            style: const TextStyle(color: AppTheme.textWhite, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.surfaceCard,
              hintText: 'Session Name',
              hintStyle: const TextStyle(color: AppTheme.textDim),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.surfaceBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.surfaceBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryGold),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Set session duration header
          Center(
            child: Column(
              children: [
                const Text(
                  'Set session duration',
                  style: TextStyle(
                    color: AppTheme.textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'drag to adjust',
                  style: TextStyle(color: AppTheme.textDim, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Circular Analog Clock with Hands (Interactive drag/tap)
          Center(
            child: GestureDetector(
              onPanUpdate: (details) {
                // Dragging to adjust time
                final dy = details.delta.dy;
                if (dy < -2 && _selectedMinutes < 120) {
                  setState(
                    () =>
                        _selectedMinutes = (_selectedMinutes + 5).clamp(5, 120),
                  );
                } else if (dy > 2 && _selectedMinutes > 5) {
                  setState(
                    () =>
                        _selectedMinutes = (_selectedMinutes - 5).clamp(5, 120),
                  );
                }
              },
              child: CustomPaint(
                size: const Size(230, 230),
                painter: _AnalogClockPainter(durationMinutes: _selectedMinutes),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Quick selection duration chips
          // Wrap works like a Row, but when the chips don't fit on one line,
          // it moves the rest to the next line instead of overflowing.
          Wrap(
            alignment: WrapAlignment.center, // center each line of chips
            spacing: 8, // horizontal gap between chips
            runSpacing: 8, // vertical gap between lines
            children: [15, 20, 25, 45, 60].map((mins) {
              final isSel = _selectedMinutes == mins;
              return ChoiceChip(
                label: Text('${mins}m'),
                selected: isSel,
                selectedColor: AppTheme.primaryGold,
                backgroundColor: AppTheme.surfaceCard,
                labelStyle: TextStyle(
                  color: isSel ? Colors.black : AppTheme.textMuted,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                onSelected: (_) => setState(() => _selectedMinutes = mins),
              );
            }).toList(),
          ),
          const SizedBox(height: 26),

          // Action Options List
          _buildOptionTile(
            icon: Icons.calendar_today_outlined,
            title: 'Programme a session',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session added to AI Study Plan')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildOptionTile(
            icon: Icons.add,
            title: 'Add a friend to the session',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invite link copied!')),
              );
            },
          ),
          const SizedBox(height: 14),

          // Receive Notification Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Receive Notification',
                style: TextStyle(
                  color: AppTheme.textWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: _receiveNotifications,
                activeColor: AppTheme.primaryGold,
                onChanged: (val) => setState(() => _receiveNotifications = val),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Bottom Buttons: Cancel & Start now
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedMinutes = 20);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1B22),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                      side: const BorderSide(color: AppTheme.surfaceBorder),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton(
                  onPressed: _startSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Start now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // SCREEN 2: Active Focus Session (Matching Image 3)
  // -------------------------------------------------------------
  Widget _buildActiveScreen() {
    final totalSec = _selectedMinutes * 60;
    final progress = totalSec == 0 ? 0.0 : (_secondsElapsed) / totalSec;
    final liveEarnings = (_secondsElapsed * 0.0104).toStringAsFixed(
      2,
    ); // ~$12.50 for 20m

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Session Name Title
            Text(
              _sessionNameController.text.trim().isEmpty
                  ? 'Focus session'
                  : _sessionNameController.text.trim(),
              style: const TextStyle(
                color: AppTheme.textWhite,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 36),

            // Active Countdown Circular Clock
            CustomPaint(
              size: const Size(260, 260),
              painter: _ActiveTimerPainter(
                progress: progress,
                digitalTime: _formatDigital(_remainingSeconds),
              ),
            ),
            const SizedBox(height: 48),

            // Controls: Play, Pause, Stop
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play
                IconButton(
                  onPressed: _isRunning ? null : _resumeSession,
                  iconSize: 34,
                  icon: Icon(
                    Icons.play_arrow,
                    color: !_isRunning
                        ? AppTheme.primaryGold
                        : AppTheme.textDim,
                  ),
                ),
                const SizedBox(width: 24),

                // Pause
                IconButton(
                  onPressed: _isRunning ? _pauseSession : null,
                  iconSize: 32,
                  icon: Icon(
                    Icons.pause,
                    color: _isRunning ? Colors.white : AppTheme.textDim,
                  ),
                ),
                const SizedBox(width: 24),

                // Stop
                IconButton(
                  onPressed: _finishSession,
                  iconSize: 28,
                  icon: const Icon(Icons.stop_rounded, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Bottom Metrics: Earned so far & session earnings
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Earned so far: ',
                      style: TextStyle(
                        color: AppTheme.textWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${AppState.instance.balance.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        color: AppTheme.primaryGold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'session earnings: ',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                    Text(
                      '+\$$liveEarnings',
                      style: const TextStyle(
                        color: AppTheme.depositGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textWhite, size: 20),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textWhite,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// Analog Clock Painter for Setup (Image 2)
// -------------------------------------------------------------
class _AnalogClockPainter extends CustomPainter {
  final int durationMinutes;

  _AnalogClockPainter({required this.durationMinutes});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Dark blue clock background with subtle shadow
    final bgPaint = Paint()
      ..color =
          const Color(0xFF1F2F4D) // Dark blue face from screenshot
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Minute Ticks
    final tickPaint = Paint()
      ..color = const Color(0xFF3B4E70)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 60; i++) {
      final angle = (i * 6) * pi / 180;
      final isMajor = i % 5 == 0;
      final tickLength = isMajor ? 8.0 : 4.0;
      final start = Offset(
        center.dx + (radius - 12) * cos(angle),
        center.dy + (radius - 12) * sin(angle),
      );
      final end = Offset(
        center.dx + (radius - 12 - tickLength) * cos(angle),
        center.dy + (radius - 12 - tickLength) * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // Yellow Hands (Matching Image 2)
    final handPaint = Paint()
      ..color = AppTheme.primaryGold
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Hour hand (approx 2 o'clock)
    final hourAngle = (durationMinutes * 6 - 90) * pi / 180;
    final hourHandEnd = Offset(
      center.dx + (radius * 0.5) * cos(hourAngle),
      center.dy + (radius * 0.5) * sin(hourAngle),
    );
    canvas.drawLine(center, hourHandEnd, handPaint);

    // Minute hand (pointing to 3 o'clock / horizontal)
    final minuteHandEnd = Offset(center.dx + (radius * 0.65), center.dy);
    canvas.drawLine(center, minuteHandEnd, handPaint);

    // Center pin
    final pinPaint = Paint()..color = AppTheme.primaryGold;
    canvas.drawCircle(center, 4, pinPaint);
  }

  @override
  bool shouldRepaint(covariant _AnalogClockPainter oldDelegate) {
    return oldDelegate.durationMinutes != durationMinutes;
  }
}

// -------------------------------------------------------------
// Active Countdown Painter (Image 3)
// -------------------------------------------------------------
class _ActiveTimerPainter extends CustomPainter {
  final double progress;
  final String digitalTime;

  _ActiveTimerPainter({required this.progress, required this.digitalTime});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Dark Blue dial
    final bgPaint = Paint()
      ..color = const Color(0xFF1E2F4C)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Perimeter tick marks
    final tickPaint = Paint()
      ..color = const Color(0xFF354B70)
      ..strokeWidth = 1.2;

    for (int i = 0; i < 60; i++) {
      final angle = (i * 6) * pi / 180;
      final tickLength = (i % 5 == 0) ? 6.0 : 3.0;
      final start = Offset(
        center.dx + (radius - 10) * cos(angle),
        center.dy + (radius - 10) * sin(angle),
      );
      final end = Offset(
        center.dx + (radius - 10 - tickLength) * cos(angle),
        center.dy + (radius - 10 - tickLength) * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // Active Yellow Arc
    final arcPaint = Paint()
      ..color = AppTheme.primaryGold
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 3),
      -pi / 2,
      sweep,
      false,
      arcPaint,
    );

    // Center Digital Time Text (20:00)
    final textPainter = TextPainter(
      text: TextSpan(
        text: digitalTime,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 38,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _ActiveTimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.digitalTime != digitalTime;
  }
}
