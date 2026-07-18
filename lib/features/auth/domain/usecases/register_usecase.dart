import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/core/usecase/usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/entities/barber_user.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<BarberUser, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, BarberUser>> call(RegisterParams params) {
    return repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      phone: params.phone,
      shopName: params.shopName,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String shopName;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.shopName,
  });

  @override
  List<Object?> get props => [email, password, name, phone, shopName];
}
