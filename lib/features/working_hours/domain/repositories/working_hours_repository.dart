import 'package:dartz/dartz.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/entities/working_hours.dart';

abstract class WorkingHoursRepository {
  Future<Either<Failure, List<WorkingHours>>> getWorkingHours(String barberShopId);
  Future<Either<Failure, void>> updateWorkingHours(List<WorkingHours> workingHours);
}
