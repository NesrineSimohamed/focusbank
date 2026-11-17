enum TransactionType { deposit, withdrawal }

class BankTransaction {
  final String id;
  final String title;
  final String description;
  final int coins;
  final TransactionType type;
  final DateTime date;
  final String category; // 'Study', 'Bonus', 'Reward', 'Shop'

  BankTransaction({
    required this.id,
    required this.title,
    required this.description,
    required this.coins,
    required this.type,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'coins': coins,
    'type': type.index,
    'date': date.toIso8601String(),
    'category': category,
  };

  factory BankTransaction.fromJson(Map<String, dynamic> json) => BankTransaction(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    coins: json['coins'] as int,
    type: TransactionType.values[json['type'] as int],
    date: DateTime.parse(json['date'] as String),
    category: json['category'] as String,
  );
}
