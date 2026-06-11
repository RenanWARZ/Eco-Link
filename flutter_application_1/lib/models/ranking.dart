import 'user.dart';

class Ranking {
  final int? id;
  final User? user;
  final int totalPoints;
  final int? rank;

  Ranking({
    this.id,
    this.user,
    required this.totalPoints,
    this.rank,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      id: json['id'] as int?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt(),
    );
  }
}
