enum ActivityType { schedule, complaint, recycling, achievement }

ActivityType activityTypeFromString(String? value) {
  switch (value) {
    case 'SCHEDULE':
      return ActivityType.schedule;
    case 'COMPLAINT':
      return ActivityType.complaint;
    case 'ACHIEVEMENT':
      return ActivityType.achievement;
    case 'RECYCLING':
    default:
      return ActivityType.recycling;
  }
}

class Activity {
  final int? id;
  final ActivityType type;
  final String description;
  final int pointsEarned;
  final DateTime? createdAt;

  Activity({
    this.id,
    required this.type,
    required this.description,
    this.pointsEarned = 0,
    this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int?,
      type: activityTypeFromString(json['type'] as String?),
      description: json['description'] as String? ?? '',
      pointsEarned: (json['pointsEarned'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}
