import 'package:dartz/dartz.dart';
import 'package:berber_sepeti_is_ortagim/core/error/exceptions.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/data/datasources/barber_dashboard_remote_data_source.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/data/models/appointment_model.dart'; // EKLENDİ
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/repositories/barber_dashboard_repository.dart';

/// Berber panosu repository uygulaması.
class BarberDashboardRepositoryImpl implements BarberDashboardRepository {
  final BarberDashboardRemoteDataSource remoteDataSource;

  const BarberDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Appointment>>> getDailyAppointments({
    required String barberShopId,
    required DateTime date,
  }) async {
    try {
      final result = await remoteDataSource.getDailyAppointments(
        barberShopId: barberShopId,
        date: date,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateAppointmentStatus({
    required String appointmentId,
    required AppointmentStatus status,
    String? notes,
  }) async {
    try {
      await remoteDataSource.updateAppointmentStatus(
        appointmentId: appointmentId,
        status: status.name, // "pending", "confirmed" vb.
        notes: notes,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> createAppointment({
    required Appointment appointment,
  }) async {
    try {
      final model = AppointmentModel(
        id: appointment.id,
        barberShopId: appointment.barberShopId,
        barberShopName: appointment.barberShopName,
        userId: appointment.userId, // Manuel randevularda null veya boş olabilir
        customerName: appointment.customerName,
        serviceId: appointment.serviceId,
        serviceName: appointment.serviceName,
        servicePrice: appointment.servicePrice,
        appointmentDate: appointment.appointmentDate,
        serviceDurationMinutes: appointment.serviceDurationMinutes,
        status: appointment.status,
        notes: appointment.notes,
        createdAt: appointment.createdAt,
      );
      await remoteDataSource.createAppointment(appointment: model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
