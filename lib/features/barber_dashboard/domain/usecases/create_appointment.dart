import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/core/usecase/usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/repositories/barber_dashboard_repository.dart';

class CreateAppointment implements UseCase<void, CreateAppointmentParams> {
  final BarberDashboardRepository repository;

  CreateAppointment(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateAppointmentParams params) async {
    return await repository.createAppointment(appointment: params.appointment);
  }
}

class CreateAppointmentParams extends Equatable {
  final Appointment appointment;

  const CreateAppointmentParams({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}
