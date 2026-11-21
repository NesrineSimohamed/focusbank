import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final DatabaseService instance = DatabaseService._internal();
  factory DatabaseService() => instance;
  DatabaseService._internal();

  /// Gets the user document snapshot from users/{uid}.
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return doc.data();
      }
    } catch (e) {
      debugPrint('DatabaseService.getUserData error: $e');
    }
    return null;
  }

  /// Saves or updates the user profile and progress fields in users/{uid}.
  Future<void> saveUserProgress({
    required String uid,
    required int balance,
    required int totalMinutesFocused,
    required int sessionCount,
    required int streakDays,
    required String lastActiveDate,
    required Map<String, int> dailyFocusMinutes,
    Map<String, Map<String, dynamic>>? subjectFocusStats,
    Map<String, Map<String, Map<String, dynamic>>>? dailySubjectStats,
    List<BankTransaction>? recentTransactions,
  }) async {
    try {
      final payload = <String, dynamic>{
        'balance': balance,
        'totalMinutesFocused': totalMinutesFocused,
        'sessionCount': sessionCount,
        'streakDays': streakDays,
        'lastActiveDate': lastActiveDate,
        'dailyFocusMinutes': dailyFocusMinutes,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (subjectFocusStats != null) {
        payload['subjectFocusStats'] = subjectFocusStats;
      }
      if (dailySubjectStats != null) {
        payload['dailySubjectStats'] = dailySubjectStats;
      }
      if (recentTransactions != null) {
        payload['recentTransactions'] =
            recentTransactions.take(50).map((tx) => tx.toJson()).toList();
      }
      await _db.collection('users').doc(uid).set(
        payload,
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('DatabaseService.saveUserProgress error: $e');
    }
  }

  /// Appends a new transaction document in users/{uid}/transactions
  Future<void> saveTransaction({
    required String uid,
    required BankTransaction transaction,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toJson());
    } catch (e) {
      debugPrint('DatabaseService.saveTransaction error: $e');
    }
  }

  /// Fetches recent transactions from users/{uid}/transactions
  Future<List<BankTransaction>> getTransactions(String uid, {int limit = 30}) async {
    try {
      final snap = await _db
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      return snap.docs
          .map((doc) => BankTransaction.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('DatabaseService.getTransactions error: $e');
      return [];
    }
  }
}
