part of 'barber_dashboard_bloc.dart';

/// Berber panosu olayları.
abstract class BarberDashboardEvent extends Equatable {
  const BarberDashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Günlük randevuları yükle olayı.
class LoadDailyAppointmentsEvent extends BarberDashboardEvent {
  final String barberShopId;
  final DateTime date;

  const LoadDailyAppointmentsEvent({
    required this.barberShopId,
    required this.date,
  });

  @override
  List<Object?> get props => [barberShopId, date];
}

/// Randevu durumu güncelleme olayı.
class UpdateAppointmentStatusEvent extends BarberDashboardEvent {
  final String appointmentId;
  final AppointmentStatus status;
  final String? notes;
  final String barberShopId; // Listeyi tekrar yüklemek için
  final DateTime selectedDate; // Listeyi tekrar yüklemek için

  const UpdateAppointmentStatusEvent({
    required this.appointmentId,
    required this.status,
    this.notes,
    required this.barberShopId,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [appointmentId, status, notes, barberShopId, selectedDate];
}

/// Tarihi değiştir olayı.
class ChangeDateEvent extends BarberDashboardEvent {
  final DateTime newDate;

  const ChangeDateEvent({required this.newDate});

  @override
  List<Object?> get props => [newDate];
}

/// Yeni manuel randevu oluşturma olayı.
class CreateAppointmentEvent extends BarberDashboardEvent {
  final Appointment appointment;
  final String barberShopId; // Listeyi yenilemek için
  final DateTime selectedDate; // Listeyi yenilemek için

  const CreateAppointmentEvent({
    required this.appointment,
    required this.barberShopId,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [appointment, barberShopId, selectedDate];
}
