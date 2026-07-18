import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/core/usecase/usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/entities/working_hours.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/repositories/working_hours_repository.dart';

class UpdateWorkingHours implements UseCase<void, UpdateWorkingHoursParams> {
  final WorkingHoursRepository repository;

  UpdateWorkingHours(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateWorkingHoursParams params) async {
    return await repository.updateWorkingHours(params.workingHours);
  }
}

class UpdateWorkingHoursParams extends Equatable {
  final List<WorkingHours> workingHours;

  const UpdateWorkingHoursParams({required this.workingHours});

  @override
  List<Object?> get props => [workingHours];
}
