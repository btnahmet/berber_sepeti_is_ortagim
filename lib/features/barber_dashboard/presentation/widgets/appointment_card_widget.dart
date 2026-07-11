import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';

/// Tek bir randevuyu gösteren kart widget'ı.
class AppointmentCardWidget extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCardWidget({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final endTime = appointment.appointmentTime
        .add(Duration(minutes: appointment.durationMinutes));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(appointment.status),
          child: Text(
            timeFormat.format(appointment.appointmentTime),
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
        ),
        title: Text(
          appointment.customerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${appointment.serviceName} • ${timeFormat.format(appointment.appointmentTime)} - ${timeFormat.format(endTime)}',
        ),
        trailing: _buildStatusChip(appointment.status),
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    return Chip(
      label: Text(
        _getStatusText(status),
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: _getStatusColor(status),
      padding: EdgeInsets.zero,
    );
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.rejected:
        return Colors.red;
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Bekliyor';
      case AppointmentStatus.confirmed:
        return 'Onaylı';
      case AppointmentStatus.rejected:
        return 'Reddedildi';
      case AppointmentStatus.completed:
        return 'Tamamlandı';
      case AppointmentStatus.cancelled:
        return 'İptal';
    }
  }
}
