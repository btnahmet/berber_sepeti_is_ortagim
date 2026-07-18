import 'package:equatable/equatable.dart';

/// Randevu entity sınıfı.
class Appointment extends Equatable {
  final String id;
  final String barberShopId;
  final String barberShopName;
  final String? userId;
  final String? customerName;
  final String? serviceId;
  final String serviceName;
  final double servicePrice;
  final DateTime appointmentDate;
  final int serviceDurationMinutes;
  final AppointmentStatus status;
  final String? notes;
  final DateTime? createdAt;

  const Appointment({
    required this.id,
    required this.barberShopId,
    required this.barberShopName,
    this.userId,
    this.customerName,
    this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.appointmentDate,
    required this.serviceDurationMinutes,
    required this.status,
    this.notes,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        barberShopId,
        barberShopName,
        userId,
        customerName,
        serviceId,
        serviceName,
        servicePrice,
        appointmentDate,
        serviceDurationMinutes,
        status,
        notes,
        createdAt,
      ];
}

enum AppointmentStatus {
  pending,
  confirmed,
  rejected,
  completed,
  cancelled,
}
