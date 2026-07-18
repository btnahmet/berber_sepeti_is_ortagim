import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:berber_sepeti_is_ortagim/core/constants/app_constants.dart';
import 'package:berber_sepeti_is_ortagim/core/error/exceptions.dart';
import 'package:berber_sepeti_is_ortagim/core/network/supabase_client_provider.dart';
import 'package:berber_sepeti_is_ortagim/features/services/data/models/service_model.dart';

abstract class ServicesRemoteDataSource {
  Future<List<ServiceModel>> getServices(String barberShopId);
  Future<void> addService(ServiceModel service);
  Future<void> updateService(ServiceModel service);
  Future<void> deleteService(String serviceId);
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  @override
  Future<List<ServiceModel>> getServices(String barberShopId) async {
    try {
      final response = await SupabaseClientProvider.client
          .from('services')
          .select()
          .eq('barber_shop_id', barberShopId)
          .order('name', ascending: true);

      return (response as List).map((e) => ServiceModel.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Hizmetler yüklenirken beklenmeyen bir hata oluştu: $e');
    }
  }

  @override
  Future<void> addService(ServiceModel service) async {
    try {
      await SupabaseClientProvider.client
          .from('services')
          .insert(service.toJson());
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Hizmet eklenirken beklenmeyen bir hata oluştu: $e');
    }
  }

  @override
  Future<void> updateService(ServiceModel service) async {
    try {
      await SupabaseClientProvider.client
          .from('services')
          .update(service.toJson())
          .eq('id', service.id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Hizmet güncellenirken beklenmeyen bir hata oluştu: $e');
    }
  }

  @override
  Future<void> deleteService(String serviceId) async {
    try {
      await SupabaseClientProvider.client
          .from('services')
          .delete()
          .eq('id', serviceId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Hizmet silinirken beklenmeyen bir hata oluştu: $e');
    }
  }
}
