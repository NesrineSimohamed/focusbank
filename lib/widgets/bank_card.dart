import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BankCard extends StatelessWidget {
  final String cardHolder;
  final int balance;
  final int streakDays;
  final double totalHours;

  const BankCard({
    super.key,
    required this.cardHolder,
    required this.balance,
    required this.streakDays,
    required this.totalHours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 215,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C2411), // Dark bronze-gold
            Color(0xFF1E1E26), // Charcoal obsidian
            Color(0xFF121216),
          ],
        ),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Logo & Chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'FocusBank',
                    style: TextStyle(
                      color: AppTheme.textWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              // Streak badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Text('🔥 ', style: TextStyle(fontSize: 12)),
                    Text(
                      '$streakDays Day Streak',
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Middle: Coin Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AVAILABLE FOCUS BALANCE',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$balance',
                    style: const TextStyle(
                      color: AppTheme.primaryGold,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'FocusCoins (FC)',
                    style: TextStyle(
                      color: AppTheme.goldLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Bottom: Card Holder & Total Study Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ACCOUNT HOLDER',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 9,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cardHolder.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.textWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'TOTAL DEPOSITED',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 9,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${totalHours.toStringAsFixed(1)} hrs focus',
                    style: const TextStyle(
                      color: AppTheme.goldLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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
