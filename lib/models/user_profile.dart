class UserProfile {
  final String name;
  final String email;
  final String dreamCareer;
  final String academicGoal;
  final int dailyGoalMinutes;
  final String preferredTime; // Morning, Afternoon, Evening, Night
  final List<String> subjects;

  UserProfile({
    required this.name,
    this.email = '',
    required this.dreamCareer,
    required this.academicGoal,
    required this.dailyGoalMinutes,
    required this.preferredTime,
    required this.subjects,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'dreamCareer': dreamCareer,
    'academicGoal': academicGoal,
    'dailyGoalMinutes': dailyGoalMinutes,
    'preferredTime': preferredTime,
    'subjects': subjects,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String? ?? 'User',
    email: json['email'] as String? ?? '',
    dreamCareer: json['dreamCareer'] as String? ?? 'Senior Eng',
    academicGoal: json['academicGoal'] as String? ?? 'Master Focus Habits',
    dailyGoalMinutes: json['dailyGoalMinutes'] as int? ?? 120,
    preferredTime: json['preferredTime'] as String? ?? 'Evening',
    subjects: (json['subjects'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [
      'Mobile App Dev',
      'Algorithms',
      'Mathematics',
      'System Design',
    ],
  );

  static UserProfile defaultProfile() => UserProfile(
    name: 'Ralph Edwards',
    email: 'ralph.edwards@focusbank.app',
    dreamCareer: 'Senior Eng',
    academicGoal: 'Pass exams with top honors',
    dailyGoalMinutes: 120,
    preferredTime: 'Evening',
    subjects: ['Mobile App Dev', 'Algorithms', 'Mathematics', 'System Design'],
  );
}
