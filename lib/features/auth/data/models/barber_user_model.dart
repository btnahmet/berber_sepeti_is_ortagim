import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/entities/barber_user.dart';

class BarberUserModel extends BarberUser {
  const BarberUserModel({
    required super.id,
    required super.email,
    super.barberShopId,
    super.name,
  });

  factory BarberUserModel.fromSupabaseUser(User user, {String? barberShopId, String? name}) {
    return BarberUserModel(
      id: user.id,
      email: user.email ?? '',
      barberShopId: barberShopId,
      name: name,
    );
  }
}
