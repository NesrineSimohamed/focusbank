import 'dart:math';
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bank_card.dart';
import '../widgets/transaction_tile.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const DashboardScreen({super.key, required this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 0 = current week, -1 = last week, -2 = 2 weeks ago, etc.
  int? _weekOffset = 0;
  int get _safeWeekOffset => _weekOffset ?? 0;

  // When non-null, pie chart shows that specific day's sessions; when null, shows the whole selected week
  DateTime? _selectedDay;

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> _weekdayShort = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  DateTime _mondayOfWeek(DateTime date) {
    final clean = DateTime(date.year, date.month, date.day);
    return clean.subtract(Duration(days: clean.weekday - 1));
  }

  String _formatShortDate(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.day}';
  }

  String _formatDayLabel(DateTime date) {
    return '${_weekdayShort[date.weekday - 1]}, ${_formatShortDate(date)}';
  }

  String _formatWeekHeader(DateTime monday, int offset) {
    final sunday = monday.add(const Duration(days: 6));
    final range = '${_formatShortDate(monday)} - ${_formatShortDate(sunday)}';
    if (offset == 0) return 'This Week ($range)';
    if (offset == -1) return 'Last Week ($range)';
    return range;
  }

  String _formatMinutesSummary(int minutes) {
    if (minutes >= 60) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return m > 0 ? '${h}h ${m}m' : '${h}h';
    }
    return '$minutes min';
  }

  Future<void> _pickAnyDate(DateTime currentMonday, DateTime accountCreatedAt) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDate = accountCreatedAt.isAfter(today) ? today : accountCreatedAt;
    DateTime initial = _selectedDay ?? today;
    if (initial.isBefore(firstDate)) initial = firstDate;
    if (initial.isAfter(today)) initial = today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryGold,
              onPrimary: Colors.black,
              surface: AppTheme.surfaceCard,
              onSurface: AppTheme.textWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null) return;
    final pickedMonday = _mondayOfWeek(picked);
    final diffWeeks = pickedMonday.difference(currentMonday).inDays ~/ 7;
    setState(() {
      _weekOffset = diffWeeks > 0 ? 0 : diffWeeks;
      _selectedDay = DateTime(picked.year, picked.month, picked.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final profile = state.profile;
        final transactions = state.transactions;

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final accountCreatedAt = state.accountCreatedAt;
        final currentMonday = _mondayOfWeek(today);
        final minMonday = _mondayOfWeek(accountCreatedAt);
        final rawSelectedMonday =
            currentMonday.add(Duration(days: _safeWeekOffset * 7));
        final selectedMonday = rawSelectedMonday.isBefore(minMonday)
            ? minMonday
            : rawSelectedMonday;
        final canGoPrevWeek = selectedMonday.isAfter(minMonday);
        final canGoNextWeek = selectedMonday.isBefore(currentMonday);
        final effectiveWeekOffset =
            selectedMonday.difference(currentMonday).inDays ~/ 7;
        final selectedWeekMinutes = state.getWeekMinutesFocused(selectedMonday);
        final maxDayMinutes = state.getMaxMinutesInWeek(selectedMonday);
        final referenceMax = maxDayMinutes > 60 ? maxDayMinutes : 60;

        // Active day always defaults to today on first open; pie chart is strictly per-day
        final DateTime rawActiveDay = _selectedDay ?? today;
        final DateTime activeDay = rawActiveDay.isBefore(accountCreatedAt)
            ? accountCreatedAt
            : rawActiveDay;
        final bool isActiveDayToday = activeDay.year == today.year &&
            activeDay.month == today.month &&
            activeDay.day == today.day;

        final List<SubjectFocusStat> pieStats =
            state.getSubjectStatsForDate(activeDay);
        final String pieScopeLabel = isActiveDayToday
            ? 'Today • ${_formatDayLabel(activeDay)}'
            : _formatDayLabel(activeDay);

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Greeting Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WELCOME BACK,',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile.name,
                            style: const TextStyle(
                              color: AppTheme.textWhite,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Career Goal Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.school, size: 14, color: AppTheme.primaryGold),
                            const SizedBox(width: 6),
                            Text(
                              profile.dreamCareer,
                              style: const TextStyle(
                                color: AppTheme.goldLight,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // The FocusBank Gold Debit Card
                  BankCard(
                    cardHolder: profile.name,
                    balance: state.balance,
                    streakDays: state.streakDays,
                    totalHours: state.totalHoursFocused,
                  ),
                  const SizedBox(height: 20),

                  // Quick Action Hub
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.timer,
                          title: 'Deposit Time',
                          subtitle: 'Start Focus',
                          color: AppTheme.primaryGold,
                          onTap: () => widget.onNavigateTab(2), // Go to Timer
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.auto_awesome,
                          title: 'AI Planner',
                          subtitle: 'Weekly Schedule',
                          color: AppTheme.infoBlue,
                          onTap: () => widget.onNavigateTab(3), // Go to Planner
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Spend Coins',
                          subtitle: 'Rewards Shop',
                          color: AppTheme.depositGreen,
                          onTap: () => widget.onNavigateTab(1), // Go to Shop
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Study Momentum / Weekly Bar Overview with Week Switcher & Clickable Days
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Weekly Deposit Activity',
                              style: TextStyle(
                                color: AppTheme.textWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatMinutesSummary(selectedWeekMinutes),
                              style: const TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Week Navigation Bar (< Prev | Week Range + Calendar | Next >)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF15151E),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.surfaceBorder),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.chevron_left_rounded,
                                  color: canGoPrevWeek
                                      ? AppTheme.textWhite
                                      : AppTheme.textMuted.withValues(alpha: 0.35),
                                  size: 20,
                                ),
                                visualDensity: VisualDensity.compact,
                                tooltip: canGoPrevWeek
                                    ? 'Previous week'
                                    : 'Account creation week',
                                onPressed: canGoPrevWeek
                                    ? () {
                                        final prevMonday = selectedMonday
                                            .subtract(const Duration(days: 7));
                                        final prevSunday = prevMonday
                                            .add(const Duration(days: 6));
                                        final defaultDay = prevSunday
                                                .isBefore(accountCreatedAt)
                                            ? accountCreatedAt
                                            : prevSunday;
                                        setState(() {
                                          _weekOffset = effectiveWeekOffset - 1;
                                          _selectedDay = defaultDay;
                                        });
                                      }
                                    : null,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _pickAnyDate(
                                    currentMonday,
                                    accountCreatedAt,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_rounded,
                                          size: 13,
                                          color: AppTheme.primaryGold,
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            _formatWeekHeader(
                                              selectedMonday,
                                              effectiveWeekOffset,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppTheme.textWhite,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.chevron_right_rounded,
                                  color: canGoNextWeek
                                      ? AppTheme.textWhite
                                      : AppTheme.textMuted.withValues(alpha: 0.35),
                                  size: 20,
                                ),
                                visualDensity: VisualDensity.compact,
                                tooltip: 'Next week',
                                onPressed: canGoNextWeek
                                    ? () {
                                        final nextOffset =
                                            effectiveWeekOffset + 1;
                                        final nextMonday = selectedMonday
                                            .add(const Duration(days: 7));
                                        final nextSunday = nextMonday
                                            .add(const Duration(days: 6));
                                        setState(() {
                                          _weekOffset = nextOffset;
                                          _selectedDay = nextOffset == 0
                                              ? today
                                              : nextSunday;
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Interactive 7-day Bar Chart (tap any day to view its pie chart)
                        Builder(
                          builder: (context) {
                            const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                            const dayFullNames = [
                              'Monday',
                              'Tuesday',
                              'Wednesday',
                              'Thursday',
                              'Friday',
                              'Saturday',
                              'Sunday'
                            ];

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(7, (index) {
                                final dayDate =
                                    selectedMonday.add(Duration(days: index));
                                final minutes = state.getMinutesForDate(dayDate);
                                final isToday = (today.year == dayDate.year &&
                                    today.month == dayDate.month &&
                                    today.day == dayDate.day);
                                final isBeforeAccount =
                                    dayDate.isBefore(accountCreatedAt);
                                final isSelected = !isBeforeAccount &&
                                    activeDay.year == dayDate.year &&
                                    activeDay.month == dayDate.month &&
                                    activeDay.day == dayDate.day;
                                final heightRatio = minutes > 0
                                    ? (minutes / referenceMax).clamp(0.18, 1.0)
                                    : 0.08;

                                return _DayBar(
                                  day: dayLabels[index],
                                  fullName:
                                      '${dayFullNames[index]}, ${_formatShortDate(dayDate)}',
                                  minutes: minutes,
                                  heightRatio: heightRatio,
                                  isToday: isToday,
                                  isSelected: isSelected,
                                  isDisabled: isBeforeAccount,
                                  onTap: isBeforeAccount
                                      ? null
                                      : () {
                                          setState(() {
                                            _selectedDay = dayDate;
                                          });
                                        },
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Session Breakdown Pie Chart (strictly for the selected day)
                  _SessionPieChartCard(
                    stats: pieStats,
                    scopeLabel: pieScopeLabel,
                    isDayFiltered: true,
                    onClearDayFilter: null,
                  ),
                  const SizedBox(height: 24),

                  // Recent Transactions Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Passbook & Ledger',
                        style: TextStyle(
                          color: AppTheme.textWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${transactions.length} entries',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Transactions List
                  if (transactions.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: const Text(
                        'No transactions recorded yet.\nStart your first focus session!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                    )
                  else
                    ...transactions.take(5).map(
                          (tx) => TransactionTile(transaction: tx),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textWhite,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DayBar extends StatelessWidget {
  final String day;
  final String fullName;
  final int minutes;
  final double heightRatio;
  final bool isToday;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _DayBar({
    required this.day,
    required this.fullName,
    required this.minutes,
    required this.heightRatio,
    required this.isToday,
    required this.isSelected,
    this.isDisabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasFocus = minutes > 0;
    final durationText = minutes >= 60
        ? '${minutes ~/ 60}h${minutes % 60 > 0 ? '${minutes % 60}m' : ''}'
        : '${minutes}m';

    final isHighlighted = !isDisabled && (isSelected || isToday);

    return Tooltip(
      message: isDisabled
          ? '$fullName: Before account creation'
          : '$fullName: ${hasFocus ? '$durationText focused' : 'No focus recorded'}',
      child: Opacity(
        opacity: isDisabled ? 0.35 : 1.0,
        child: GestureDetector(
          onTap: isDisabled ? null : onTap,
          behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: isSelected
              ? BoxDecoration(
                  color: AppTheme.primaryGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.primaryGold.withValues(alpha: 0.7),
                    width: 1.2,
                  ),
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Minutes label above bar
              SizedBox(
                height: 16,
                child: hasFocus
                    ? Text(
                        durationText,
                        style: TextStyle(
                          color: isHighlighted
                              ? AppTheme.primaryGold
                              : AppTheme.textMuted,
                          fontSize: 10,
                          fontWeight:
                              isHighlighted ? FontWeight.bold : FontWeight.w500,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 4),

              // Bar Container
              Container(
                height: 70,
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: isSelected ? 18 : 16,
                  height: 70 * heightRatio,
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? AppTheme.primaryGold
                        : hasFocus
                            ? AppTheme.primaryGold.withValues(alpha: 0.6)
                            : AppTheme.surfaceBorder.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                    gradient: isHighlighted
                        ? const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [AppTheme.goldDark, AppTheme.primaryGold],
                          )
                        : hasFocus
                            ? LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  AppTheme.primaryGold.withValues(alpha: 0.35),
                                  AppTheme.primaryGold.withValues(alpha: 0.7),
                                ],
                              )
                            : null,
                    boxShadow: isHighlighted && hasFocus
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryGold.withValues(alpha: 0.35),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Day Label below bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: isSelected
                    ? BoxDecoration(
                        color: AppTheme.primaryGold,
                        borderRadius: BorderRadius.circular(4),
                      )
                    : isToday
                        ? BoxDecoration(
                            color: AppTheme.primaryGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          )
                        : null,
                child: Text(
                  day,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.black
                        : isToday
                            ? AppTheme.primaryGold
                            : AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight:
                        isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}


class _SessionPieChartCard extends StatelessWidget {
  final List<SubjectFocusStat> stats;
  final String scopeLabel;
  final bool isDayFiltered;
  final VoidCallback? onClearDayFilter;

  const _SessionPieChartCard({
    required this.stats,
    required this.scopeLabel,
    this.isDayFiltered = false,
    this.onClearDayFilter,
  });

  String _formatDuration(int minutes) {
    if (minutes >= 60) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return m > 0 ? '${h}h ${m}m' : '${h}h';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final totalMinutes = stats.fold<int>(0, (sum, item) => sum + item.minutes);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Session Breakdown',
                      style: TextStyle(
                        color: AppTheme.textWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scopeLabel,
                      style: const TextStyle(
                        color: AppTheme.primaryGold,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDayFiltered && onClearDayFilter != null)
                InkWell(
                  onTap: onClearDayFilter,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGold.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Text(
                      'Show Week',
                      style: TextStyle(
                        color: AppTheme.primaryGold,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                Text(
                  stats.length == 1
                      ? '1 session type'
                      : '${stats.length} session types',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (stats.isEmpty || totalMinutes == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.pie_chart_outline_rounded,
                    color: AppTheme.textMuted,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      isDayFiltered
                          ? 'No sessions recorded on $scopeLabel.'
                          : 'No sessions recorded for this week yet.',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Donut / Pie Chart
                SizedBox(
                  width: 132,
                  height: 132,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(132, 132),
                        painter: _PieChartPainter(
                          stats: stats,
                          totalMinutes: totalMinutes,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatDuration(totalMinutes),
                            style: const TextStyle(
                              color: AppTheme.textWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 9,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),

                // Legend list with percentages & tag colors
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: stats.map((stat) {
                      final pct = ((stat.minutes / totalMinutes) * 100).round();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: stat.color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: stat.color.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stat.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppTheme.textWhite,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(stat.minutes),
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$pct%',
                              style: TextStyle(
                                color: stat.color,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<SubjectFocusStat> stats;
  final int totalMinutes;

  _PieChartPainter({
    required this.stats,
    required this.totalMinutes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (stats.isEmpty || totalMinutes <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = 22.0;
    final radius = (min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -pi / 2; // Start at 12 o'clock
    final gapAngle = stats.length > 1 ? 0.04 : 0.0;

    for (final stat in stats) {
      final rawSweep = (stat.minutes / totalMinutes) * 2 * pi;
      final sweepAngle = max(0.02, rawSweep - gapAngle);

      final paint = Paint()
        ..color = stat.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle + gapAngle / 2, sweepAngle, false, paint);
      startAngle += rawSweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.stats != stats || oldDelegate.totalMinutes != totalMinutes;
  }
}
