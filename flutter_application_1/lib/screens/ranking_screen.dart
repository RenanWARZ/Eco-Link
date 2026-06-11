import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ranking.dart';
import '../services/auth_service.dart';
import '../services/ranking_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/page_header.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Ranking> _rankings = [];
  Ranking? _myRanking;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = context.read<AuthService>().currentUser?.id;
    try {
      final top = await RankingService.getTopRankings();
      Ranking? mine;
      if (uid != null) {
        mine = await RankingService.getByUserId(uid);
      }
      if (!mounted) return;
      setState(() {
        _rankings = top;
        _myRanking = mine;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _medal(int pos) {
    switch (pos) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthService>().currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.headerRanking.colors.last,
        title: const Text('Ranking'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: AppColors.green,
        child: ListView(
          children: [
            PageHeader(
              title: 'Ranking',
              subtitle: 'Os cidadãos mais sustentáveis',
              gradient: AppColors.headerRanking,
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_myRanking != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Text(
                              _medal(_myRanking!.rank ?? 99).isNotEmpty
                                  ? _medal(_myRanking!.rank ?? 99)
                                  : '#${_myRanking!.rank}',
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.green),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(currentUser?.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  Text('${_myRanking!.totalPoints} pontos', style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 18),
                  const Text('Top Recicladores', style: TextStyle(fontFamily: 'DM Sans', fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (_loading)
                    const LoadingState()
                  else if (_rankings.isEmpty)
                    const EmptyState(icon: '🏆', message: 'Nenhum dado ainda.')
                  else
                    ..._rankings.asMap().entries.map((entry) {
                      final i = entry.key;
                      final r = entry.value;
                      final isMe = r.user?.id == currentUser?.id;
                      return Card(
                        color: isMe ? AppColors.greenBg : AppColors.white,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: isMe ? AppColors.greenLine : AppColors.line),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  _medal(i + 1).isNotEmpty ? _medal(i + 1) : '${i + 1}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontFamily: 'DM Sans', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.inkMuted),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.user?.name ?? 'Usuário', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                    Text(r.user?.email ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${r.totalPoints}', style: const TextStyle(fontFamily: 'DM Sans', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.green)),
                                  const Text('PTS', style: TextStyle(fontSize: 10, color: AppColors.inkMuted, letterSpacing: 0.5)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
