import 'package:dartz/dartz.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/core/usecase/usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/entities/barber_user.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase extends UseCase<BarberUser?, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, BarberUser?>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
