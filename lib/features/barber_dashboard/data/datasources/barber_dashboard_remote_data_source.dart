import 'package:berber_sepeti_is_ortagim/core/constants/app_constants.dart';
import 'package:berber_sepeti_is_ortagim/core/error/exceptions.dart';
import 'package:berber_sepeti_is_ortagim/core/network/supabase_client_provider.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/data/models/appointment_model.dart';

/// Berber panosu uzak veri kaynağı arayüzü.
abstract class BarberDashboardRemoteDataSource {
  /// Belirli bir güne ait randevuları Supabase'den çeker.
  Future<List<AppointmentModel>> getDailyAppointments({
    required String barberId,
    required DateTime date,
  });
}

/// Berber panosu uzak veri kaynağı uygulaması.
class BarberDashboardRemoteDataSourceImpl
    implements BarberDashboardRemoteDataSource {
  @override
  Future<List<AppointmentModel>> getDailyAppointments({
    required String barberId,
    required DateTime date,
  }) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await SupabaseClientProvider.client
          .from(AppConstants.appointmentsTable)
          .select()
          .eq('barber_id', barberId)
          .gte('appointment_time', startOfDay.toIso8601String())
          .lt('appointment_time', endOfDay.toIso8601String())
          .order('appointment_time', ascending: true);

      return (response as List)
          .map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Randevular yüklenirken bir hata oluştu: $e');
    }
  }
}
