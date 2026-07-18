import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:berber_sepeti_is_ortagim/core/error/exceptions.dart';
import 'package:berber_sepeti_is_ortagim/core/network/supabase_client_provider.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/data/models/working_hours_model.dart';

abstract class WorkingHoursRemoteDataSource {
  Future<List<WorkingHoursModel>> getWorkingHours(String barberShopId);
  Future<void> updateWorkingHours(List<WorkingHoursModel> workingHours);
}

class WorkingHoursRemoteDataSourceImpl implements WorkingHoursRemoteDataSource {
  @override
  Future<List<WorkingHoursModel>> getWorkingHours(String barberShopId) async {
    try {
      final response = await SupabaseClientProvider.client
          .from('working_hours')
          .select()
          .eq('barber_shop_id', barberShopId)
          .order('day_of_week', ascending: true);

      final List<WorkingHoursModel> hours = (response as List)
          .map((e) => WorkingHoursModel.fromJson(e))
          .toList();

      // Eğer hiç saat ayarlanmamışsa, default 7 günü oluşturup geri dönelim
      if (hours.isEmpty) {
        final defaultHours = _generateDefaultWorkingHours(barberShopId);
        // Arka planda veritabanına ekle
        await updateWorkingHours(defaultHours);
        return defaultHours;
      }

      return hours;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Çalışma saatleri yüklenirken hata oluştu: $e');
    }
  }

  @override
  Future<void> updateWorkingHours(List<WorkingHoursModel> workingHours) async {
    try {
      final data = workingHours.map((e) => e.toJson()).toList();
      await SupabaseClientProvider.client
          .from('working_hours')
          .upsert(data, onConflict: 'barber_shop_id, day_of_week'); 
          // Not: upsert için tabloda barber_shop_id ve day_of_week'ten oluşan bir unique constraint (veya id) olması lazım
          // Biz direkt tüm listeyi upsert yapıyoruz
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Çalışma saatleri güncellenirken hata oluştu: $e');
    }
  }

  List<WorkingHoursModel> _generateDefaultWorkingHours(String barberShopId) {
    return List.generate(7, (index) {
      final dayOfWeek = index + 1;
      return WorkingHoursModel(
        id: const Uuid().v4(),
        barberShopId: barberShopId,
        dayOfWeek: dayOfWeek,
        openingTime: '09:00',
        closingTime: '20:00',
        isClosed: dayOfWeek == 7, // Pazar günü kapalı olsun varsayılan olarak
      );
    });
  }
}
