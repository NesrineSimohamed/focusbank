class RewardItem {
  final String id;
  final String title;
  final String description;
  final int costCoins;
  final String iconEmoji;
  final String category; // 'Break', 'Treat', 'Entertainment', 'Custom'
  final bool isCustom;
  int timesRedeemed;

  RewardItem({
    required this.id,
    required this.title,
    required this.description,
    required this.costCoins,
    required this.iconEmoji,
    required this.category,
    this.isCustom = false,
    this.timesRedeemed = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'costCoins': costCoins,
    'iconEmoji': iconEmoji,
    'category': category,
    'isCustom': isCustom,
    'timesRedeemed': timesRedeemed,
  };

  factory RewardItem.fromJson(Map<String, dynamic> json) => RewardItem(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    costCoins: json['costCoins'] as int,
    iconEmoji: json['iconEmoji'] as String? ?? '🎁',
    category: json['category'] as String? ?? 'Treat',
    isCustom: json['isCustom'] as bool? ?? false,
    timesRedeemed: json['timesRedeemed'] as int? ?? 0,
  );
}
