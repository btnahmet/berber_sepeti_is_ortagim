import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';

/// Randevu veri modeli - JSON dönüşümlerini yönetir.
class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.barberId,
    required super.customerName,
    required super.serviceName,
    required super.appointmentTime,
    required super.durationMinutes,
    required super.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      barberId: json['barber_id'] as String,
      customerName: json['customer_name'] as String? ?? 'Bilinmeyen Müşteri',
      serviceName: json['service_name'] as String? ?? 'Belirtilmemiş',
      appointmentTime: DateTime.parse(json['appointment_time'] as String),
      durationMinutes: json['duration_minutes'] as int? ?? 30,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'pending'),
        orElse: () => AppointmentStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barber_id': barberId,
      'customer_name': customerName,
      'service_name': serviceName,
      'appointment_time': appointmentTime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'status': status.name,
    };
  }
}
