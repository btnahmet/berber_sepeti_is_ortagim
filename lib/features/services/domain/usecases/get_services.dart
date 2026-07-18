import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/core/usecase/usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/entities/service.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/repositories/services_repository.dart';

class GetServices implements UseCase<List<Service>, GetServicesParams> {
  final ServicesRepository repository;

  GetServices(this.repository);

  @override
  Future<Either<Failure, List<Service>>> call(GetServicesParams params) async {
    return await repository.getServices(params.barberShopId);
  }
}

class GetServicesParams extends Equatable {
  final String barberShopId;

  const GetServicesParams({required this.barberShopId});

  @override
  List<Object?> get props => [barberShopId];
}
