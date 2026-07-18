import 'package:equatable/equatable.dart';

/// Sisteme giriş yapan berberin temel bilgilerini tutan entity sınıfı.
class BarberUser extends Equatable {
  final String id; // auth.users id
  final String email;
  final String? barberShopId; // barber_shops tablosundaki id
  final String? name;

  const BarberUser({
    required this.id,
    required this.email,
    this.barberShopId,
    this.name,
  });

  @override
  List<Object?> get props => [id, email, barberShopId, name];
}
