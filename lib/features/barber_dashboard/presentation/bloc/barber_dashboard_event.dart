part of 'barber_dashboard_bloc.dart';

/// Berber panosu olayları.
abstract class BarberDashboardEvent extends Equatable {
  const BarberDashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Günlük randevuları yükle olayı.
class LoadDailyAppointmentsEvent extends BarberDashboardEvent {
  final String barberId;
  final DateTime date;

  const LoadDailyAppointmentsEvent({
    required this.barberId,
    required this.date,
  });

  @override
  List<Object?> get props => [barberId, date];
}

/// Tarihi değiştir olayı.
class ChangeDateEvent extends BarberDashboardEvent {
  final DateTime newDate;

  const ChangeDateEvent({required this.newDate});

  @override
  List<Object?> get props => [newDate];
}
