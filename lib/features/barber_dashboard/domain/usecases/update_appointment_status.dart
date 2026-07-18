import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/core/usecase/usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/repositories/barber_dashboard_repository.dart';

class UpdateAppointmentStatus implements UseCase<void, UpdateAppointmentStatusParams> {
  final BarberDashboardRepository repository;

  UpdateAppointmentStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateAppointmentStatusParams params) async {
    return await repository.updateAppointmentStatus(
      appointmentId: params.appointmentId,
      status: params.status,
      notes: params.notes,
    );
  }
}

class UpdateAppointmentStatusParams extends Equatable {
  final String appointmentId;
  final AppointmentStatus status;
  final String? notes;

  const UpdateAppointmentStatusParams({
    required this.appointmentId,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [appointmentId, status, notes];
}
