part of 'barber_dashboard_bloc.dart';

/// Berber panosu durumları.
abstract class BarberDashboardState extends Equatable {
  const BarberDashboardState();

  @override
  List<Object?> get props => [];
}

/// Başlangıç durumu.
class BarberDashboardInitial extends BarberDashboardState {}

/// Yükleniyor durumu.
class BarberDashboardLoading extends BarberDashboardState {}

/// Randevular yüklendi durumu.
class BarberDashboardLoaded extends BarberDashboardState {
  final List<Appointment> appointments;
  final DateTime selectedDate;

  const BarberDashboardLoaded({
    required this.appointments,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [appointments, selectedDate];
}

/// Hata durumu.
class BarberDashboardError extends BarberDashboardState {
  final String message;

  const BarberDashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
