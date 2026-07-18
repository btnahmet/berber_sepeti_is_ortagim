import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/core/usecase/usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/entities/working_hours.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/repositories/working_hours_repository.dart';

class GetWorkingHours implements UseCase<List<WorkingHours>, GetWorkingHoursParams> {
  final WorkingHoursRepository repository;

  GetWorkingHours(this.repository);

  @override
  Future<Either<Failure, List<WorkingHours>>> call(GetWorkingHoursParams params) async {
    return await repository.getWorkingHours(params.barberShopId);
  }
}

class GetWorkingHoursParams extends Equatable {
  final String barberShopId;

  const GetWorkingHoursParams({required this.barberShopId});

  @override
  List<Object?> get props => [barberShopId];
}
