import 'package:dartz/dartz.dart';
import 'package:berber_sepeti_is_ortagim/core/error/exceptions.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/data/datasources/working_hours_remote_data_source.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/data/models/working_hours_model.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/entities/working_hours.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/repositories/working_hours_repository.dart';

class WorkingHoursRepositoryImpl implements WorkingHoursRepository {
  final WorkingHoursRemoteDataSource remoteDataSource;

  WorkingHoursRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WorkingHours>>> getWorkingHours(String barberShopId) async {
    try {
      final result = await remoteDataSource.getWorkingHours(barberShopId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateWorkingHours(List<WorkingHours> workingHours) async {
    try {
      final models = workingHours.map((wh) => WorkingHoursModel(
        id: wh.id,
        barberShopId: wh.barberShopId,
        dayOfWeek: wh.dayOfWeek,
        openingTime: wh.openingTime,
        closingTime: wh.closingTime,
        isClosed: wh.isClosed,
      )).toList();

      await remoteDataSource.updateWorkingHours(models);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
