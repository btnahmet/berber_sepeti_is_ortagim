import 'package:dartz/dartz.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/entities/barber_user.dart';

abstract class AuthRepository {
  /// Giriş yapar
  Future<Either<Failure, BarberUser>> login({
    required String email,
    required String password,
  });

  /// Yeni berber kaydı oluşturur ve dükkan bilgilerini kaydeder
  Future<Either<Failure, BarberUser>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String shopName,
  });

  /// Çıkış yapar
  Future<Either<Failure, void>> logout();

  /// Mevcut oturumdaki kullanıcıyı getirir (varsa)
  Future<Either<Failure, BarberUser?>> getCurrentUser();
}
