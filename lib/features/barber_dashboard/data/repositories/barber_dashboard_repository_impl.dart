import 'package:dartz/dartz.dart';
import 'package:berber_sepeti_is_ortagim/core/error/exceptions.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/data/datasources/barber_dashboard_remote_data_source.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/repositories/barber_dashboard_repository.dart';

/// Berber panosu repository uygulaması.
class BarberDashboardRepositoryImpl implements BarberDashboardRepository {
  final BarberDashboardRemoteDataSource remoteDataSource;

  const BarberDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Appointment>>> getDailyAppointments({
    required String barberId,
    required DateTime date,
  }) async {
    try {
      final appointments = await remoteDataSource.getDailyAppointments(
        barberId: barberId,
        date: date,
      );
      return Right(appointments);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
