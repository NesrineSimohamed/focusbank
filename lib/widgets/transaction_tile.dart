import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final BankTransaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == TransactionType.deposit;
    final color = isDeposit ? AppTheme.depositGreen : AppTheme.withdrawRed;
    final prefix = isDeposit ? '+ ' : '- ';
    final iconData = isDeposit ? Icons.arrow_downward : Icons.arrow_upward;

    final dateStr = '${transaction.date.day.toString().padLeft(2, '0')}/${transaction.date.month.toString().padLeft(2, '0')} ${transaction.date.hour.toString().padLeft(2, '0')}:${transaction.date.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder, width: 0.8),
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: color, size: 20),
          ),
          const SizedBox(width: 14),

          // Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: AppTheme.textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '$dateStr • ${transaction.description}',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Amount in FocusCoins
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$prefix${transaction.coins} FC',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                transaction.category,
                style: const TextStyle(
                  color: AppTheme.textDim,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
