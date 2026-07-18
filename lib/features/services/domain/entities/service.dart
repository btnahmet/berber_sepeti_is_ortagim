import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String id;
  final String barberShopId;
  final String name;
  final double price;
  final int durationMinutes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Service({
    required this.id,
    required this.barberShopId,
    required this.name,
    required this.price,
    required this.durationMinutes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        barberShopId,
        name,
        price,
        durationMinutes,
        isActive,
        createdAt,
        updatedAt,
      ];
}
