import 'package:berber_sepeti_is_ortagim/core/constants/app_constants.dart';
import 'package:berber_sepeti_is_ortagim/core/error/exceptions.dart';
import 'package:berber_sepeti_is_ortagim/core/network/supabase_client_provider.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/data/models/appointment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Berber panosu uzak veri kaynağı arayüzü.
abstract class BarberDashboardRemoteDataSource {
  /// Belirli bir güne ait randevuları Supabase'den çeker.
  Future<List<AppointmentModel>> getDailyAppointments({
    required String barberShopId,
    required DateTime date,
  });

  /// Belirtilen randevunun durumunu (ve gerekirse notunu) günceller.
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
    String? notes,
  });

  /// Berberin manuel randevu oluşturmasını sağlar.
  Future<void> createAppointment({
    required AppointmentModel appointment,
  });
}

/// Berber panosu uzak veri kaynağı uygulaması.
class BarberDashboardRemoteDataSourceImpl
    implements BarberDashboardRemoteDataSource {
  @override
  Future<List<AppointmentModel>> getDailyAppointments({
    required String barberShopId,
    required DateTime date,
  }) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day).toIso8601String();
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();

      final response = await SupabaseClientProvider.client
          .from(AppConstants.appointmentsTable)
          .select()
          .eq('barber_shop_id', barberShopId)
          .gte('appointment_date', startOfDay)
          .lte('appointment_date', endOfDay)
          .order('appointment_date', ascending: true);

      return (response as List).map((e) => AppointmentModel.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Randevular yüklenirken beklenmeyen bir hata oluştu: $e');
    }
  }

  @override
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
    String? notes,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
      };
      
      if (notes != null) {
        updateData['notes'] = notes;
      }

      await SupabaseClientProvider.client
          .from(AppConstants.appointmentsTable)
          .update(updateData)
          .eq('id', appointmentId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Durum güncellenirken beklenmeyen bir hata oluştu: $e');
    }
  }

  @override
  Future<void> createAppointment({
    required AppointmentModel appointment,
  }) async {
    try {
      await SupabaseClientProvider.client
          .from(AppConstants.appointmentsTable)
          .insert(appointment.toJson());
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Randevu eklenirken beklenmeyen bir hata oluştu: $e');
    }
  }
}
