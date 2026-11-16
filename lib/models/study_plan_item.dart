class StudyPlanItem {
  final String id;
  final String day; // 'Monday', 'Tuesday', etc.
  final String timeSlot; // '09:00 - 10:30', 'Evening'
  final String subject;
  final String objective;
  final int durationMinutes;
  bool isCompleted;

  StudyPlanItem({
    required this.id,
    required this.day,
    required this.timeSlot,
    required this.subject,
    required this.objective,
    required this.durationMinutes,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'day': day,
    'timeSlot': timeSlot,
    'subject': subject,
    'objective': objective,
    'durationMinutes': durationMinutes,
    'isCompleted': isCompleted,
  };

  factory StudyPlanItem.fromJson(Map<String, dynamic> json) => StudyPlanItem(
    id: json['id'] as String,
    day: json['day'] as String,
    timeSlot: json['timeSlot'] as String,
    subject: json['subject'] as String,
    objective: json['objective'] as String,
    durationMinutes: json['durationMinutes'] as int,
    isCompleted: json['isCompleted'] as bool? ?? false,
  );
}
