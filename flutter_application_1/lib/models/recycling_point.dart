import 'dart:convert';

class RecyclingPoint {
  final int? id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String types;
  final int? capacity;
  final int currentLoad;
  final bool isActive;

  RecyclingPoint({
    this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.types,
    this.capacity,
    this.currentLoad = 0,
    this.isActive = true,
  });

  factory RecyclingPoint.fromJson(Map<String, dynamic> json) {
    return RecyclingPoint(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      types: json['types'] as String? ?? '[]',
      capacity: (json['capacity'] as num?)?.toInt(),
      currentLoad: (json['currentLoad'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  List<String> get typesList {
    try {
      final decoded = jsonDecode(types);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [types];
    } catch (_) {
      return [types];
    }
  }

  double get occupancyRate {
    if (capacity == null || capacity == 0) return 0;
    return (currentLoad / capacity!) * 100;
  }
}
