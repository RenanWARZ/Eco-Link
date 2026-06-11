import '../models/user.dart';
import 'api_client.dart';

class UserService {
  static Future<User> createOrUpdate(User user) async {
    final json = await ApiClient.post('/users', body: user.toJson());
    return User.fromJson(json as Map<String, dynamic>);
  }

  static Future<User?> getById(int id) async {
    final json = await ApiClient.get('/users/$id');
    return json != null ? User.fromJson(json as Map<String, dynamic>) : null;
  }

  static Future<User> updatePoints(int id, int points) async {
    final json = await ApiClient.put('/users/$id/points', query: {'points': points});
    return User.fromJson(json as Map<String, dynamic>);
  }
}
