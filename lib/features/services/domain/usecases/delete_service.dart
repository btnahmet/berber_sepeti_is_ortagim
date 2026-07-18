import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/core/usecase/usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/repositories/services_repository.dart';

class DeleteService implements UseCase<void, DeleteServiceParams> {
  final ServicesRepository repository;

  DeleteService(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteServiceParams params) async {
    return await repository.deleteService(params.serviceId);
  }
}

class DeleteServiceParams extends Equatable {
  final String serviceId;

  const DeleteServiceParams({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}
