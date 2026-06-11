import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/recycling_point.dart';
import '../services/recycling_point_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/page_header.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _maringa = LatLng(-23.4253, -51.9386);

  final MapController _mapController = MapController();
  List<RecyclingPoint> _points = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final points = await RecyclingPointService.getAllActive();
      if (!mounted) return;
      setState(() {
        _points = points;
        _loading = false;
      });
      if (points.isNotEmpty) {
        _mapController.move(LatLng(points.first.latitude, points.first.longitude), 13);
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _focus(RecyclingPoint p) {
    _mapController.move(LatLng(p.latitude, p.longitude), 16);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.green,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          PageHeader(
            title: 'Mapa de Reciclagem',
            subtitle: '${_points.length} pontos ativos em Maringá',
            gradient: AppColors.headerGreen,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 260,
                child: FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    initialCenter: _maringa,
                    initialZoom: 12,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.ecolink.app',
                    ),
                    MarkerLayer(
                      markers: _points
                          .map((p) => Marker(
                                point: LatLng(p.latitude, p.longitude),
                                width: 36,
                                height: 36,
                                child: GestureDetector(
                                  onTap: () => _showPointSheet(p),
                                  child: const Icon(Icons.location_on, color: AppColors.green, size: 36),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _loading
                ? const LoadingState()
                : _points.isEmpty
                    ? const EmptyState(icon: '🗺', message: 'Nenhum ponto cadastrado ainda.')
                    : Column(
                        children: _points.map((p) => _PointCard(point: p, onTap: () => _focus(p))).toList(),
                      ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showPointSheet(RecyclingPoint p) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(p.address, style: const TextStyle(fontSize: 13, color: AppColors.inkMuted)),
          ],
        ),
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  final RecyclingPoint point;
  final VoidCallback onTap;

  const _PointCard({required this.point, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(point.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(point.address, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: point.isActive ? AppColors.greenBg : AppColors.line,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      point.isActive ? 'Ativo' : 'Inativo',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: point.isActive ? AppColors.green : AppColors.inkSoft,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: point.typesList
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.greenBg, borderRadius: BorderRadius.circular(99)),
                          child: Text(t, style: const TextStyle(fontSize: 11, color: AppColors.green, fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
              ),
              if (point.capacity != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: (point.occupancyRate / 100).clamp(0, 1),
                          minHeight: 4,
                          backgroundColor: AppColors.line,
                          valueColor: const AlwaysStoppedAnimation(AppColors.green),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${point.occupancyRate.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
