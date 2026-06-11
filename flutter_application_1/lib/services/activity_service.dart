import '../models/activity.dart';
import 'api_client.dart';

class ActivityService {
  static Future<List<Activity>> getByUserId(int userId) async {
    final json = await ApiClient.get('/activities/user/$userId');
    return (json as List? ?? [])
        .map((e) => Activity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Activity>> getUserHistory(int userId) async {
    final json = await ApiClient.get('/activities/user/$userId/history');
    return (json as List? ?? [])
        .map((e) => Activity.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
