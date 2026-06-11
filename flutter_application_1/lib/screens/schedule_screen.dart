import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/schedule.dart';
import '../services/auth_service.dart';
import '../services/schedule_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/page_header.dart';
import '../widgets/status_badge.dart';

const _wasteTypes = [
  'plástico',
  'papel',
  'vidro',
  'metal',
  'eletrônico',
  'orgânico',
  'misto',
];

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _addressController = TextEditingController();
  final _latController = TextEditingController(text: '0');
  final _lngController = TextEditingController(text: '0');
  final _descriptionController = TextEditingController();

  String? _wasteType;
  DateTime? _scheduledDate;
  bool _saving = false;
  bool _loading = true;
  List<Schedule> _schedules = [];
  String? _toast;
  bool _toastIsError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final uid = context.read<AuthService>().currentUser?.id;
    if (uid == null) return;
    try {
      final list = await ScheduleService.getByUserId(uid);
      if (!mounted) return;
      setState(() {
        _schedules = list;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showToast(String message, {bool isError = false}) {
    setState(() {
      _toast = message;
      _toastIsError = isError;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  Future<void> _useMyLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showToast('Permissão de localização negada.', isError: true);
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      _latController.text = pos.latitude.toString();
      _lngController.text = pos.longitude.toString();
    } catch (_) {
      _showToast('Não foi possível obter a localização.', isError: true);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledDate ?? now),
    );
    if (time == null) return;
    setState(() {
      _scheduledDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    final auth = context.read<AuthService>();
    final user = auth.currentUser;
    if (user?.id == null || _wasteType == null || _addressController.text.trim().isEmpty || _scheduledDate == null) {
      _showToast('Preencha tipo, endereço e data.', isError: true);
      return;
    }
    setState(() => _saving = true);
    try {
      final schedule = Schedule(
        wasteType: _wasteType!,
        address: _addressController.text.trim(),
        latitude: double.tryParse(_latController.text) ?? 0,
        longitude: double.tryParse(_lngController.text) ?? 0,
        scheduledDate: _scheduledDate!,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      );
      final created = await ScheduleService.create(schedule, user!.toRef());
      if (!mounted) return;
      setState(() {
        _schedules = [created, ..._schedules];
        _wasteType = null;
        _addressController.clear();
        _latController.text = '0';
        _lngController.text = '0';
        _descriptionController.clear();
        _scheduledDate = null;
        _saving = false;
      });
      _showToast('Agendado!');
    } catch (_) {
      setState(() => _saving = false);
      _showToast('Erro ao agendar.', isError: true);
    }
  }

  Future<void> _cancel(Schedule schedule) async {
    if (schedule.id == null) return;
    try {
      final updated = await ScheduleService.cancel(schedule.id!);
      if (!mounted) return;
      setState(() {
        _schedules = _schedules.map((s) => s.id == updated.id ? updated : s).toList();
      });
      _showToast('Cancelado.');
    } catch (_) {
      _showToast('Erro ao cancelar.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _load,
          color: AppColors.green,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const PageHeader(
                title: 'Agendar Coleta',
                subtitle: 'Solicite coleta de resíduos em casa',
                gradient: AppColors.headerSchedule,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Novo agendamento', style: TextStyle(fontFamily: 'DM Sans', fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _wasteType,
                          decoration: const InputDecoration(labelText: 'Tipo de resíduo'),
                          items: _wasteTypes
                              .map((t) => DropdownMenuItem(value: t, child: Text(t[0].toUpperCase() + t.substring(1))))
                              .toList(),
                          onChanged: (v) => setState(() => _wasteType = v),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(labelText: 'Endereço de coleta', hintText: 'Rua, número, bairro'),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _latController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                decoration: const InputDecoration(labelText: 'Latitude'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _lngController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                decoration: const InputDecoration(labelText: 'Longitude'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Data e hora'),
                            child: Text(
                              _scheduledDate == null ? 'Selecionar…' : DateFormat('dd/MM/yyyy HH:mm').format(_scheduledDate!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(labelText: 'Observações', hintText: 'Opcional…'),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _useMyLocation,
                          icon: const Icon(Icons.my_location, size: 18),
                          label: const Text('Usar minha localização'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _saving ? null : _submit,
                          child: _saving
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Confirmar Agendamento'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Meus agendamentos', style: TextStyle(fontFamily: 'DM Sans', fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (_loading)
                      const LoadingState()
                    else if (_schedules.isEmpty)
                      const EmptyState(icon: '📅', message: 'Nenhum agendamento ainda.')
                    else
                      ..._schedules.map((s) => _ScheduleCard(schedule: s, onCancel: () => _cancel(s))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        if (_toast != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: _toastIsError ? AppColors.red : AppColors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(_toast!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onCancel;

  const _ScheduleCard({required this.schedule, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final canCancel = schedule.status == ScheduleStatus.pending || schedule.status == ScheduleStatus.confirmed;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: AppColors.line)),
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
                      Text('♻ ${schedule.wasteType}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 3),
                      Text(schedule.address, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                      Text(DateFormat('dd/MM/yyyy HH:mm').format(schedule.scheduledDate), style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                    ],
                  ),
                ),
                StatusBadge.scheduleStatus(schedule.status),
              ],
            ),
            if (canCancel) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: const Text('Cancelar', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
