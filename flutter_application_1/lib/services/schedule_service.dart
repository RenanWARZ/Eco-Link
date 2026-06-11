import '../models/schedule.dart';
import 'api_client.dart';

class ScheduleService {
  static Future<List<Schedule>> getByUserId(int userId) async {
    final json = await ApiClient.get('/schedules/user/$userId');
    return (json as List? ?? [])
        .map((e) => Schedule.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Schedule> create(
      Schedule schedule, Map<String, dynamic> userRef) async {
    final json =
        await ApiClient.post('/schedules', body: schedule.toCreateJson(userRef));
    return Schedule.fromJson(json as Map<String, dynamic>);
  }

  static Future<Schedule> cancel(int id) async {
    final json = await ApiClient.put('/schedules/$id/cancel');
    return Schedule.fromJson(json as Map<String, dynamic>);
  }
}
