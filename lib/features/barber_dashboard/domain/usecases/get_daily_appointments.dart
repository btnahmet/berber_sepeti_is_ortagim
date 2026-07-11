import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/core/usecase/usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/repositories/barber_dashboard_repository.dart';

/// Günlük randevuları getiren use case.
class GetDailyAppointments
    extends UseCase<List<Appointment>, GetDailyAppointmentsParams> {
  final BarberDashboardRepository repository;

  GetDailyAppointments(this.repository);

  @override
  Future<Either<Failure, List<Appointment>>> call(
    GetDailyAppointmentsParams params,
  ) {
    return repository.getDailyAppointments(
      barberId: params.barberId,
      date: params.date,
    );
  }
}

class GetDailyAppointmentsParams extends Equatable {
  final String barberId;
  final DateTime date;

  const GetDailyAppointmentsParams({
    required this.barberId,
    required this.date,
  });

  @override
  List<Object?> get props => [barberId, date];
}
