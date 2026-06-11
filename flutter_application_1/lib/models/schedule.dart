enum ScheduleStatus { pending, confirmed, completed, cancelled }

ScheduleStatus scheduleStatusFromString(String? value) {
  switch (value) {
    case 'CONFIRMED':
      return ScheduleStatus.confirmed;
    case 'COMPLETED':
      return ScheduleStatus.completed;
    case 'CANCELLED':
      return ScheduleStatus.cancelled;
    case 'PENDING':
    default:
      return ScheduleStatus.pending;
  }
}

class Schedule {
  final int? id;
  final String wasteType;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime scheduledDate;
  final String? description;
  final ScheduleStatus status;
  final DateTime? createdAt;

  Schedule({
    this.id,
    required this.wasteType,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.scheduledDate,
    this.description,
    this.status = ScheduleStatus.pending,
    this.createdAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as int?,
      wasteType: json['wasteType'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      scheduledDate: DateTime.tryParse(json['scheduledDate'] as String? ?? '') ??
          DateTime.now(),
      description: json['description'] as String?,
      status: scheduleStatusFromString(json['status'] as String?),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toCreateJson(Map<String, dynamic> userRef) {
    return {
      'wasteType': wasteType,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'scheduledDate': scheduledDate.toIso8601String(),
      'description': description,
      'user': userRef,
    };
  }
}
