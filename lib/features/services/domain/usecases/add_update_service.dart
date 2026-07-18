import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/core/usecase/usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/entities/service.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/repositories/services_repository.dart';

class AddService implements UseCase<void, ServiceParams> {
  final ServicesRepository repository;

  AddService(this.repository);

  @override
  Future<Either<Failure, void>> call(ServiceParams params) async {
    return await repository.addService(params.service);
  }
}

class UpdateService implements UseCase<void, ServiceParams> {
  final ServicesRepository repository;

  UpdateService(this.repository);

  @override
  Future<Either<Failure, void>> call(ServiceParams params) async {
    return await repository.updateService(params.service);
  }
}

class ServiceParams extends Equatable {
  final Service service;

  const ServiceParams({required this.service});

  @override
  List<Object?> get props => [service];
}
