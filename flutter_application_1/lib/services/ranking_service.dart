import '../models/ranking.dart';
import 'api_client.dart';

class RankingService {
  static Future<List<Ranking>> getTopRankings() async {
    final json = await ApiClient.get('/rankings');
    return (json as List? ?? [])
        .map((e) => Ranking.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Ranking?> getByUserId(int userId) async {
    final json = await ApiClient.get('/rankings/user/$userId');
    return json != null ? Ranking.fromJson(json as Map<String, dynamic>) : null;
  }
}
