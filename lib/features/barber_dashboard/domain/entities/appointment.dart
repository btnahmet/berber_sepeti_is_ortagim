import 'package:equatable/equatable.dart';

/// Randevu entity sınıfı.
class Appointment extends Equatable {
  final String id;
  final String barberId;
  final String customerName;
  final String serviceName;
  final DateTime appointmentTime;
  final int durationMinutes;
  final AppointmentStatus status;

  const Appointment({
    required this.id,
    required this.barberId,
    required this.customerName,
    required this.serviceName,
    required this.appointmentTime,
    required this.durationMinutes,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        barberId,
        customerName,
        serviceName,
        appointmentTime,
        durationMinutes,
        status,
      ];
}

enum AppointmentStatus {
  pending,
  confirmed,
  rejected,
  completed,
  cancelled,
}
