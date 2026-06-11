import '../models/complaint.dart';
import 'api_client.dart';

class ComplaintService {
  static Future<List<Complaint>> getByUserId(int userId) async {
    final json = await ApiClient.get('/complaints/user/$userId');
    return (json as List? ?? [])
        .map((e) => Complaint.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Complaint> create(
      Complaint complaint, Map<String, dynamic> userRef) async {
    final json =
        await ApiClient.post('/complaints', body: complaint.toCreateJson(userRef));
    return Complaint.fromJson(json as Map<String, dynamic>);
  }
}
