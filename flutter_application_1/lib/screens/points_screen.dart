import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';

const _achievements = [
  {'icon': '🌱', 'name': 'Iniciante', 'pts': 50},
  {'icon': '♻️', 'name': 'Reciclador', 'pts': 200},
  {'icon': '🚲', 'name': 'Eco Rider', 'pts': 500},
  {'icon': '🌍', 'name': 'Guardião', 'pts': 1000},
  {'icon': '⭐', 'name': 'Estrela Verde', 'pts': 2000},
  {'icon': '🏆', 'name': 'Campeão', 'pts': 5000},
];

const _levelThresholds = [0, 50, 200, 500, 1000, 2000];

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  List<Activity> _activities = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = context.read<AuthService>().currentUser?.id;
    if (uid == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final activities = await ActivityService.getUserHistory(uid);
      if (!mounted) return;
      setState(() {
        _activities = activities;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _currentLevel(int p) {
    if (p < 50) return '🌱 Iniciante';
    if (p < 200) return '♻️ Reciclador';
    if (p < 500) return '🚲 Eco Rider';
    if (p < 1000) return '🌍 Guardião';
    if (p < 2000) return '⭐ Estrela Verde';
    return '🏆 Campeão Eco';
  }

  String _nextLevelMsg(int p) {
    for (final t in [50, 200, 500, 1000, 2000]) {
      if (p < t) return 'Faltam ${t - p} pts para o próximo nível';
    }
    return 'Nível máximo atingido!';
  }

  double _progressPct(int p) {
    for (var i = 0; i < _levelThresholds.length - 1; i++) {
      final lo = _levelThresholds[i];
      final hi = _levelThresholds[i + 1];
      if (p >= lo && p < hi) return (p - lo) / (hi - lo);
    }
    return 1;
  }

  Color _typeColor(ActivityType type) {
    switch (type) {
      case ActivityType.schedule:
        return AppColors.blue;
      case ActivityType.complaint:
        return AppColors.red;
      case ActivityType.recycling:
        return AppColors.green;
      case ActivityType.achievement:
        return AppColors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final points = user?.points ?? 0;

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.green,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            decoration: const BoxDecoration(gradient: AppColors.headerGreen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GAMIFICAÇÃO',
                  style: TextStyle(fontSize: 11, letterSpacing: 1, color: Colors.white.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('$points', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(width: 6),
                    Text('pts', style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.7))),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(_currentLevel(points), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: _progressPct(points),
                    minHeight: 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Text(_nextLevelMsg(points), style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.65))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Conquistas', style: TextStyle(fontFamily: 'DM Sans', fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.95,
                  children: _achievements.map((a) {
                    final pts = a['pts'] as int;
                    final unlocked = points >= pts;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: unlocked ? AppColors.greenLine : AppColors.line),
                      ),
                      child: Opacity(
                        opacity: unlocked ? 1 : 0.35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(a['icon'] as String, style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 4),
                            Text(
                              a['name'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.ink),
                            ),
                            Text('$pts pts', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text('Histórico', style: TextStyle(fontFamily: 'DM Sans', fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (_loading)
                  const LoadingState()
                else if (_activities.isEmpty)
                  const EmptyState(icon: '🌱', message: 'Nenhuma atividade ainda.')
                else
                  Column(
                    children: _activities.map((a) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(color: _typeColor(a.type), shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(a.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                    if (a.createdAt != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(DateFormat('dd/MM/yyyy').format(a.createdAt!), style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                                      ),
                                  ],
                                ),
                              ),
                              if (a.pointsEarned > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: AppColors.greenBg, borderRadius: BorderRadius.circular(99)),
                                  child: Text('+${a.pointsEarned}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.green)),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
