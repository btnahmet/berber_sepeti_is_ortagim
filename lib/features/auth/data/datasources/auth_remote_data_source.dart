import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:berber_sepeti_is_ortagim/core/constants/app_constants.dart';
import 'package:berber_sepeti_is_ortagim/core/error/exceptions.dart';
import 'package:berber_sepeti_is_ortagim/core/network/supabase_client_provider.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/data/models/barber_user_model.dart';
import 'package:uuid/uuid.dart';

abstract class AuthRemoteDataSource {
  Future<BarberUserModel> login({required String email, required String password});
  Future<BarberUserModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String shopName,
  });
  Future<void> logout();
  Future<BarberUserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client = SupabaseClientProvider.client;

  @override
  Future<BarberUserModel> login({required String email, required String password}) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException('Kullanıcı bulunamadı.');
      }

      // Berber profili bilgisini al
      final profile = await _getBarberProfile(response.user!.id);
      
      return BarberUserModel.fromSupabaseUser(
        response.user!,
        barberShopId: profile?['id'] as String?,
        name: profile?['name'] as String?,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BarberUserModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String shopName,
  }) async {
    try {
      // 1. Supabase Auth'a kayıt yap
      final authResponse = await client.auth.signUp(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user == null) {
        throw ServerException('Kayıt işlemi başarısız oldu.');
      }

      // 2. barber_shops tablosuna veri ekle
      // appointments tablosu barber_shop_id'yi text beklediği için UUID string olarak yollayacağız
      final shopId = const Uuid().v4();
      
      await client.from(AppConstants.barberShopsTable).insert({
        'id': shopId,
        'user_id': user.id,
        'name': name,
        'phone': phone,
        'email': email,
        'address': '', // Başlangıçta boş bırakılabilir
        'is_active': true,
      });

      return BarberUserModel.fromSupabaseUser(
        user,
        barberShopId: shopId,
        name: name,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BarberUserModel?> getCurrentUser() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) return null;

      final profile = await _getBarberProfile(user.id);

      return BarberUserModel.fromSupabaseUser(
        user,
        barberShopId: profile?['id'] as String?,
        name: profile?['name'] as String?,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getBarberProfile(String userId) async {
    try {
      final response = await client
          .from(AppConstants.barberShopsTable)
          .select('id, name')
          .eq('user_id', userId)
          .maybeSingle();
      return response;
    } catch (_) {
      return null;
    }
  }
}
