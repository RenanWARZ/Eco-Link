import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../models/ranking.dart';
import '../services/activity_service.dart';
import '../services/auth_service.dart';
import '../services/ranking_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import 'ranking_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int index) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Activity> _activities = [];
  Ranking? _myRanking;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = context.read<AuthService>().currentUser?.id;
    if (uid == null) return;
    try {
      final activities = await ActivityService.getByUserId(uid);
      final ranking = await RankingService.getByUserId(uid);
      if (!mounted) return;
      setState(() {
        _activities = activities;
        _myRanking = ranking;
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
    final firstName = (user?.name.split(' ').first.isNotEmpty ?? false)
        ? user!.name.split(' ').first
        : 'Olá';

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.green,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            decoration: const BoxDecoration(gradient: AppColors.headerGreen),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, $firstName',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bem-vindo ao EcoLink',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${user?.points ?? 0}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'PTS',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.6),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                          Container(width: 3, height: 36, color: AppColors.green, margin: const EdgeInsets.only(right: 12)),
                          Text(
                            _medal(_myRanking!.rank ?? 99).isNotEmpty
                                ? _medal(_myRanking!.rank ?? 99)
                                : '#${_myRanking!.rank}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.green),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('SUA POSIÇÃO', style: TextStyle(fontSize: 11, color: AppColors.inkMuted, letterSpacing: 0.5)),
                                Text('${_myRanking!.totalPoints} pontos acumulados', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const RankingScreen()),
                            ),
                            child: const Text('Ver ranking →', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.green)),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text('Ações', style: TextStyle(fontFamily: 'DM Sans', fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.6,
                  children: [
                    _ActionCard(
                      icon: '◎',
                      label: 'Pontos de\nReciclagem',
                      bg: AppColors.greenBg,
                      fg: AppColors.green,
                      onTap: () => widget.onNavigateTab(1),
                    ),
                    _ActionCard(
                      icon: '▦',
                      label: 'Agendar\nColeta',
                      bg: AppColors.blueBg,
                      fg: AppColors.blue,
                      onTap: () => widget.onNavigateTab(2),
                    ),
                    _ActionCard(
                      icon: '⚑',
                      label: 'Registrar\nDenúncia',
                      bg: AppColors.redBg,
                      fg: AppColors.red,
                      onTap: () => widget.onNavigateTab(3),
                    ),
                    _ActionCard(
                      icon: '◈',
                      label: 'Ver\nRanking',
                      bg: AppColors.amberBg,
                      fg: AppColors.amber,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RankingScreen()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Atividades recentes', style: TextStyle(fontFamily: 'DM Sans', fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (_loading)
                  const LoadingState()
                else if (_activities.isEmpty)
                  const EmptyState(icon: '🌱', message: 'Nenhuma atividade ainda.\nComece reciclando!')
                else
                  Column(
                    children: _activities.take(5).map((a) {
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
                                        child: Text(DateFormat('dd MMM, HH:mm').format(a.createdAt!), style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                                      ),
                                  ],
                                ),
                              ),
                              if (a.pointsEarned > 0)
                                Text('+${a.pointsEarned}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.green)),
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

class _ActionCard extends StatelessWidget {
  final String icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: Text(icon, style: TextStyle(fontSize: 16, color: fg)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
