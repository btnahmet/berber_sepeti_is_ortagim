import 'package:dartz/dartz.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/entities/service.dart';

abstract class ServicesRepository {
  Future<Either<Failure, List<Service>>> getServices(String barberShopId);
  Future<Either<Failure, void>> addService(Service service);
  Future<Either<Failure, void>> updateService(Service service);
  Future<Either<Failure, void>> deleteService(String serviceId);
}
