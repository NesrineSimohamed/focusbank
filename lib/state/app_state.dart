import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/transaction.dart';
import '../models/study_plan_item.dart';
import '../models/reward_item.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  factory AppState() => instance;
  AppState._internal() {
    _initDefaults();
  }

  bool _isLoggedIn = true;
  bool _isOnboarded = true;
  UserProfile _profile = UserProfile.defaultProfile();

  // Metrics matching the user's mockups ($52,300 earned, 142 sessions, 120h focused)
  int _balance = 52300;
  int _sessionCount = 142;
  int _totalMinutesFocused = 120 * 60;
  int _streakDays = 5;

  List<BankTransaction> _transactions = [];
  List<StudyPlanItem> _studyPlan = [];
  List<RewardItem> _rewards = [];

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isOnboarded => _isOnboarded;
  UserProfile get profile => _profile;
  int get balance => _balance;
  int get sessionCount => _sessionCount;
  int get streakDays => _streakDays;
  int get totalMinutesFocused => _totalMinutesFocused;
  double get totalHoursFocused => _totalMinutesFocused / 60.0;
  List<BankTransaction> get transactions => List.unmodifiable(_transactions);
  List<StudyPlanItem> get studyPlan => List.unmodifiable(_studyPlan);
  List<RewardItem> get rewards => List.unmodifiable(_rewards);

  void _initDefaults() {
    _transactions = [
      BankTransaction(
        id: 'tx_1',
        title: 'Focus Deposit: Mobile Architecture',
        description: 'Completed 60m solo session',
        coins: 60,
        type: TransactionType.deposit,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'Study',
      ),
      BankTransaction(
        id: 'tx_2',
        title: 'Redeemed: Coffee Break',
        description: 'Espresso recharge reward',
        coins: 50,
        type: TransactionType.withdrawal,
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Shop',
      ),
      BankTransaction(
        id: 'tx_3',
        title: 'Focus Deposit: Algorithms & Trees',
        description: 'Completed 45m deep focus block',
        coins: 50,
        type: TransactionType.deposit,
        date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        category: 'Study',
      ),
    ];

    _rewards = [
      RewardItem(
        id: 'r_1',
        title: '30m Gaming Break',
        description: 'Play on PC / Console guilt-free',
        costCoins: 35,
        iconEmoji: '🎮',
        category: 'Entertainment',
      ),
      RewardItem(
        id: 'r_2',
        title: '1 Episode of Netflix/Anime',
        description: 'Watch your favorite series',
        costCoins: 45,
        iconEmoji: '🍿',
        category: 'Entertainment',
      ),
      RewardItem(
        id: 'r_3',
        title: 'Specialty Coffee / Boba',
        description: 'Treat yourself to your favorite drink',
        costCoins: 60,
        iconEmoji: '☕',
        category: 'Treat',
      ),
      RewardItem(
        id: 'r_4',
        title: '20m Social Media Break',
        description: 'Scroll guilt-free',
        costCoins: 25,
        iconEmoji: '📱',
        category: 'Break',
      ),
      RewardItem(
        id: 'r_5',
        title: 'Weekend Celebration',
        description: 'Full evening off with friends',
        costCoins: 150,
        iconEmoji: '🎉',
        category: 'Treat',
      ),
    ];

    _generateStudyPlanFor(_profile);
  }

  void _generateStudyPlanFor(UserProfile user) {
    final timePrefix = user.preferredTime == 'Morning'
        ? '08:30 - 10:00'
        : user.preferredTime == 'Afternoon'
            ? '14:00 - 15:30'
            : user.preferredTime == 'Night'
                ? '22:00 - 23:30'
                : '19:00 - 20:30'; // Evening default

    _studyPlan = [
      StudyPlanItem(
        id: 'sp_1',
        day: 'Monday',
        timeSlot: timePrefix,
        subject: user.subjects.isNotEmpty ? user.subjects[0] : 'Mobile App Dev',
        objective: 'Timer & State Architecture setup',
        durationMinutes: 60,
        isCompleted: true,
      ),
      StudyPlanItem(
        id: 'sp_2',
        day: 'Tuesday',
        timeSlot: timePrefix,
        subject: user.subjects.length > 1 ? user.subjects[1] : 'Algorithms',
        objective: 'Data structures & problem solving',
        durationMinutes: 60,
        isCompleted: true,
      ),
      StudyPlanItem(
        id: 'sp_3',
        day: 'Wednesday',
        timeSlot: timePrefix,
        subject: user.subjects.length > 2 ? user.subjects[2] : 'Mathematics',
        objective: 'Calculus & applied problem sets',
        durationMinutes: 90,
        isCompleted: false,
      ),
      StudyPlanItem(
        id: 'sp_4',
        day: 'Thursday',
        timeSlot: timePrefix,
        subject: user.subjects.isNotEmpty ? user.subjects[0] : 'Mobile App Dev',
        objective: 'UI polish & micro-interactions',
        durationMinutes: 60,
        isCompleted: false,
      ),
      StudyPlanItem(
        id: 'sp_5',
        day: 'Friday',
        timeSlot: timePrefix,
        subject: user.subjects.length > 3 ? user.subjects[3] : 'System Design',
        objective: 'Mock exam & synthesis',
        durationMinutes: 60,
        isCompleted: false,
      ),
      StudyPlanItem(
        id: 'sp_6',
        day: 'Saturday',
        timeSlot: '10:00 - 12:00',
        subject: 'Weekly Review',
        objective: 'Comprehensive test & AI study analysis',
        durationMinutes: 120,
        isCompleted: false,
      ),
    ];
  }

  // Authentication Flow
  void login({required String email, required String password}) {
    _isLoggedIn = true;
    _isOnboarded = true;
    notifyListeners();
  }

  void signUp({
    required String name,
    required String email,
    required String password,
  }) {
    _profile = UserProfile(
      name: name.trim().isEmpty ? 'User' : name.trim(),
      email: email.trim(),
      dreamCareer: 'Student',
      academicGoal: 'Ace exams with top grades',
      dailyGoalMinutes: 90,
      preferredTime: 'Evening',
      subjects: ['Mobile App Dev', 'Algorithms', 'Mathematics', 'System Design'],
    );
    _isLoggedIn = true;
    _isOnboarded = false; // Trigger the schedule questionnaire immediately!
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  // Completing the questionnaire form
  void completeOnboarding(UserProfile newProfile) {
    _profile = newProfile;
    _isOnboarded = true;
    _generateStudyPlanFor(newProfile);
    notifyListeners();
  }

  // Recording a focus session
  void recordFocusSession({
    required String subject,
    required int minutesCompleted,
  }) {
    if (minutesCompleted <= 0) return;

    final bonus = (minutesCompleted >= 25) ? 5 : 0;
    final totalCoins = minutesCompleted + bonus;

    _balance += totalCoins;
    _totalMinutesFocused += minutesCompleted;
    _sessionCount += 1;

    final tx = BankTransaction(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Focus: $subject',
      description: 'Completed $minutesCompleted min focus session',
      coins: totalCoins,
      type: TransactionType.deposit,
      date: DateTime.now(),
      category: 'Study',
    );

    _transactions.insert(0, tx);
    notifyListeners();
  }

  // Redeem Reward
  bool redeemReward(RewardItem reward) {
    if (_balance < reward.costCoins) return false;

    _balance -= reward.costCoins;
    reward.timesRedeemed += 1;

    final tx = BankTransaction(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Redeemed: ${reward.title}',
      description: 'Shop reward redemption',
      coins: reward.costCoins,
      type: TransactionType.withdrawal,
      date: DateTime.now(),
      category: 'Shop',
    );

    _transactions.insert(0, tx);
    notifyListeners();
    return true;
  }

  void addCustomReward({
    required String title,
    required String description,
    required int costCoins,
    required String emoji,
    required String category,
  }) {
    _rewards.insert(
      0,
      RewardItem(
        id: 'r_custom_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        costCoins: costCoins,
        iconEmoji: emoji.isEmpty ? '⭐' : emoji,
        category: category,
        isCustom: true,
      ),
    );
    notifyListeners();
  }

  void toggleStudyPlanItem(String id) {
    final idx = _studyPlan.indexWhere((item) => item.id == id);
    if (idx != -1) {
      _studyPlan[idx].isCompleted = !_studyPlan[idx].isCompleted;
      notifyListeners();
    }
  }
}
