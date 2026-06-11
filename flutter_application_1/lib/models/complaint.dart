enum ComplaintPriority { low, medium, high, critical }

enum ComplaintStatus { open, inProgress, resolved, closed }

ComplaintPriority complaintPriorityFromString(String? value) {
  switch (value) {
    case 'LOW':
      return ComplaintPriority.low;
    case 'HIGH':
      return ComplaintPriority.high;
    case 'CRITICAL':
      return ComplaintPriority.critical;
    case 'MEDIUM':
    default:
      return ComplaintPriority.medium;
  }
}

String complaintPriorityToString(ComplaintPriority priority) {
  switch (priority) {
    case ComplaintPriority.low:
      return 'LOW';
    case ComplaintPriority.medium:
      return 'MEDIUM';
    case ComplaintPriority.high:
      return 'HIGH';
    case ComplaintPriority.critical:
      return 'CRITICAL';
  }
}

ComplaintStatus complaintStatusFromString(String? value) {
  switch (value) {
    case 'IN_PROGRESS':
      return ComplaintStatus.inProgress;
    case 'RESOLVED':
      return ComplaintStatus.resolved;
    case 'CLOSED':
      return ComplaintStatus.closed;
    case 'OPEN':
    default:
      return ComplaintStatus.open;
  }
}

class Complaint {
  final int? id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final ComplaintPriority priority;
  final ComplaintStatus status;
  final String? imageUrl;
  final DateTime? createdAt;

  Complaint({
    this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.priority = ComplaintPriority.medium,
    this.status = ComplaintStatus.open,
    this.imageUrl,
    this.createdAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      priority: complaintPriorityFromString(json['priority'] as String?),
      status: complaintStatusFromString(json['status'] as String?),
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toCreateJson(Map<String, dynamic> userRef) {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'priority': complaintPriorityToString(priority),
      'user': userRef,
    };
  }
}
