import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/complaint.dart';
import '../models/schedule.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  factory StatusBadge.complaintPriority(ComplaintPriority p) {
    switch (p) {
      case ComplaintPriority.low:
        return StatusBadge(label: 'Baixa', color: AppColors.green, background: AppColors.greenBg);
      case ComplaintPriority.medium:
        return StatusBadge(label: 'Média', color: AppColors.amber, background: AppColors.amberBg);
      case ComplaintPriority.high:
        return StatusBadge(label: 'Alta', color: AppColors.amber, background: AppColors.amberBg);
      case ComplaintPriority.critical:
        return StatusBadge(label: 'Crítica', color: AppColors.red, background: AppColors.redBg);
    }
  }

  factory StatusBadge.complaintStatus(ComplaintStatus s) {
    switch (s) {
      case ComplaintStatus.open:
        return StatusBadge(label: 'Aberta', color: AppColors.blue, background: AppColors.blueBg);
      case ComplaintStatus.inProgress:
        return StatusBadge(label: 'Em Andamento', color: AppColors.amber, background: AppColors.amberBg);
      case ComplaintStatus.resolved:
        return StatusBadge(label: 'Resolvida', color: AppColors.green, background: AppColors.greenBg);
      case ComplaintStatus.closed:
        return StatusBadge(label: 'Fechada', color: AppColors.inkSoft, background: AppColors.line);
    }
  }

  factory StatusBadge.scheduleStatus(ScheduleStatus s) {
    switch (s) {
      case ScheduleStatus.pending:
        return StatusBadge(label: 'Pendente', color: AppColors.amber, background: AppColors.amberBg);
      case ScheduleStatus.confirmed:
        return StatusBadge(label: 'Confirmado', color: AppColors.green, background: AppColors.greenBg);
      case ScheduleStatus.completed:
        return StatusBadge(label: 'Concluído', color: AppColors.blue, background: AppColors.blueBg);
      case ScheduleStatus.cancelled:
        return StatusBadge(label: 'Cancelado', color: AppColors.red, background: AppColors.redBg);
    }
  }
}
