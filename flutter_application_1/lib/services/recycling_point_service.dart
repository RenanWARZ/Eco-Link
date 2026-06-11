import '../models/recycling_point.dart';
import 'api_client.dart';

class RecyclingPointService {
  static Future<List<RecyclingPoint>> getAllActive() async {
    final json = await ApiClient.get('/recycling-points');
    return (json as List? ?? [])
        .map((e) => RecyclingPoint.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<RecyclingPoint>> getNearby(
      double latitude, double longitude, {double radiusKm = 5.0}) async {
    final json = await ApiClient.get('/recycling-points/nearby', query: {
      'latitude': latitude,
      'longitude': longitude,
      'radiusKm': radiusKm,
    });
    return (json as List? ?? [])
        .map((e) => RecyclingPoint.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
