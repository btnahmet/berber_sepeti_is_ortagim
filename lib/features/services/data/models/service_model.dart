import 'package:berber_sepeti_is_ortagim/features/services/domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.barberShopId,
    required super.name,
    required super.price,
    required super.durationMinutes,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      barberShopId: json['barber_shop_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      durationMinutes: json['duration_minutes'] as int,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barber_shop_id': barberShopId,
      'name': name,
      'price': price,
      'duration_minutes': durationMinutes,
      'is_active': isActive,
    };
  }
}
