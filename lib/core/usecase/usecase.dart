import 'package:dartz/dartz.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
