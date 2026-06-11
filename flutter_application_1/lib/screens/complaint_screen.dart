import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/complaint.dart';
import '../services/auth_service.dart';
import '../services/complaint_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/page_header.dart';
import '../widgets/status_badge.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latController = TextEditingController(text: '0');
  final _lngController = TextEditingController(text: '0');

  ComplaintPriority _priority = ComplaintPriority.medium;
  bool _saving = false;
  bool _loading = true;
  List<Complaint> _complaints = [];
  String? _toast;
  bool _toastIsError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final uid = context.read<AuthService>().currentUser?.id;
    if (uid == null) return;
    try {
      final list = await ComplaintService.getByUserId(uid);
      if (!mounted) return;
      setState(() {
        _complaints = list;
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

  Future<void> _submit() async {
    final auth = context.read<AuthService>();
    final user = auth.currentUser;
    if (user?.id == null || _titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      _showToast('Preencha título e descrição.', isError: true);
      return;
    }
    setState(() => _saving = true);
    try {
      final complaint = Complaint(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        latitude: double.tryParse(_latController.text) ?? 0,
        longitude: double.tryParse(_lngController.text) ?? 0,
        priority: _priority,
      );
      final created = await ComplaintService.create(complaint, user!.toRef());
      if (!mounted) return;
      setState(() {
        _complaints = [created, ..._complaints];
        _titleController.clear();
        _descriptionController.clear();
        _latController.text = '0';
        _lngController.text = '0';
        _priority = ComplaintPriority.medium;
        _saving = false;
      });
      _showToast('Denúncia registrada!');
    } catch (_) {
      setState(() => _saving = false);
      _showToast('Erro ao registrar.', isError: true);
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
                title: 'Denúncia',
                subtitle: 'Registre descartes irregulares',
                gradient: AppColors.headerComplaint,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nova ocorrência', style: TextStyle(fontFamily: 'DM Sans', fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Título', hintText: 'Ex: Lixo acumulado na calçada'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(labelText: 'Descrição', hintText: 'Descreva o problema…'),
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
                        DropdownButtonFormField<ComplaintPriority>(
                          initialValue: _priority,
                          decoration: const InputDecoration(labelText: 'Prioridade'),
                          items: const [
                            DropdownMenuItem(value: ComplaintPriority.low, child: Text('Baixa')),
                            DropdownMenuItem(value: ComplaintPriority.medium, child: Text('Média')),
                            DropdownMenuItem(value: ComplaintPriority.high, child: Text('Alta')),
                            DropdownMenuItem(value: ComplaintPriority.critical, child: Text('Crítica')),
                          ],
                          onChanged: (v) => setState(() => _priority = v ?? ComplaintPriority.medium),
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
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                          child: _saving
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Registrar Denúncia'),
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
                    const Text('Minhas denúncias', style: TextStyle(fontFamily: 'DM Sans', fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (_loading)
                      const LoadingState()
                    else if (_complaints.isEmpty)
                      const EmptyState(icon: '✓', message: 'Nenhuma denúncia registrada.')
                    else
                      ..._complaints.map((c) => _ComplaintCard(complaint: c)),
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

class _ComplaintCard extends StatelessWidget {
  final Complaint complaint;

  const _ComplaintCard({required this.complaint});

  @override
  Widget build(BuildContext context) {
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
                  child: Text(complaint.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StatusBadge.complaintPriority(complaint.priority),
                    const SizedBox(height: 4),
                    StatusBadge.complaintStatus(complaint.status),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(complaint.description, style: const TextStyle(fontSize: 13, color: AppColors.inkSoft)),
            const SizedBox(height: 6),
            if (complaint.createdAt != null)
              Text(DateFormat('dd/MM/yyyy HH:mm').format(complaint.createdAt!), style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
          ],
        ),
      ),
    );
  }
}
