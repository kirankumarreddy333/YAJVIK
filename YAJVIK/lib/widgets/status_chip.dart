import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/app_theme.dart';

Color statusColor(ApplicationStatus status) {
  switch (status) {
    case ApplicationStatus.applied:
      return AppColors.primary;
    case ApplicationStatus.examScheduled:
    case ApplicationStatus.admitCard:
      return AppColors.warning;
    case ApplicationStatus.result:
    case ApplicationStatus.interview:
      return AppColors.secondary;
    case ApplicationStatus.offer:
    case ApplicationStatus.selected:
      return const Color(0xFF2ECC71);
    case ApplicationStatus.rejected:
      return AppColors.danger;
  }
}

class StatusChip extends StatelessWidget {
  final ApplicationStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
