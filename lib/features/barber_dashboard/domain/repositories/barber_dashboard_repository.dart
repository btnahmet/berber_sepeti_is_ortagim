import 'package:dartz/dartz.dart';
import 'package:berber_sepeti_is_ortagim/core/error/failures.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';

/// Berber panosu repository arayüzü.
abstract class BarberDashboardRepository {
  /// Belirli bir güne ait randevuları getirir.
  Future<Either<Failure, List<Appointment>>> getDailyAppointments({
    required String barberId,
    required DateTime date,
  });
}
