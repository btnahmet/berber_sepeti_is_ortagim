import 'package:dartz/dartz.dart';
import 'package:berber_sepeti_is_ortagim/core/error/exceptions.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/features/services/data/datasources/services_remote_data_source.dart';
import 'package:berber_sepeti_is_ortagim/features/services/data/models/service_model.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/entities/service.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/repositories/services_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource remoteDataSource;

  ServicesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Service>>> getServices(String barberShopId) async {
    try {
      final result = await remoteDataSource.getServices(barberShopId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addService(Service service) async {
    try {
      final model = ServiceModel(
        id: service.id,
        barberShopId: service.barberShopId,
        name: service.name,
        price: service.price,
        durationMinutes: service.durationMinutes,
        isActive: service.isActive,
      );
      await remoteDataSource.addService(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateService(Service service) async {
    try {
      final model = ServiceModel(
        id: service.id,
        barberShopId: service.barberShopId,
        name: service.name,
        price: service.price,
        durationMinutes: service.durationMinutes,
        isActive: service.isActive,
      );
      await remoteDataSource.updateService(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteService(String serviceId) async {
    try {
      await remoteDataSource.deleteService(serviceId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
