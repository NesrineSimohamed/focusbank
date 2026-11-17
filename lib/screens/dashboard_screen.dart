import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bank_card.dart';
import '../widgets/transaction_tile.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int) onNavigateTab;

  const DashboardScreen({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final profile = state.profile;
        final transactions = state.transactions;

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
                          border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
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
                          onTap: () => onNavigateTab(1), // Go to Timer
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.auto_awesome,
                          title: 'AI Planner',
                          subtitle: 'Weekly Schedule',
                          color: AppTheme.infoBlue,
                          onTap: () => onNavigateTab(2), // Go to Planner
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Spend Coins',
                          subtitle: 'Rewards Shop',
                          color: AppTheme.depositGreen,
                          onTap: () => onNavigateTab(3), // Go to Shop
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Study Momentum / Weekly Bar Overview
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
                              '${state.totalMinutesFocused} min this week',
                              style: const TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Mock Visual Bar Chart of the week
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _DayBar(day: 'M', heightRatio: 0.8, isToday: false),
                            _DayBar(day: 'T', heightRatio: 0.6, isToday: false),
                            _DayBar(day: 'W', heightRatio: 0.9, isToday: false),
                            _DayBar(day: 'T', heightRatio: 0.4, isToday: false),
                            _DayBar(day: 'F', heightRatio: 0.75, isToday: false),
                            _DayBar(day: 'S', heightRatio: 0.3, isToday: false),
                            _DayBar(day: 'S', heightRatio: 1.0, isToday: true),
                          ],
                        ),
                      ],
                    ),
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
                color: color.withOpacity(0.15),
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
  final double heightRatio;
  final bool isToday;

  const _DayBar({
    required this.day,
    required this.heightRatio,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 60 * heightRatio.clamp(0.15, 1.0),
          decoration: BoxDecoration(
            color: isToday ? AppTheme.primaryGold : AppTheme.surfaceBorder,
            borderRadius: BorderRadius.circular(6),
            gradient: isToday
                ? const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppTheme.goldDark, AppTheme.primaryGold],
                  )
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: TextStyle(
            color: isToday ? AppTheme.primaryGold : AppTheme.textMuted,
            fontSize: 11,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
