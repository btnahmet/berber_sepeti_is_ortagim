import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/entities/working_hours.dart';

class WorkingHoursModel extends WorkingHours {
  const WorkingHoursModel({
    required super.id,
    required super.barberShopId,
    required super.dayOfWeek,
    required super.openingTime,
    required super.closingTime,
    required super.isClosed,
  });

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      id: json['id'] as String,
      barberShopId: json['barber_shop_id'] as String,
      dayOfWeek: json['day_of_week'] as int,
      openingTime: json['opening_time'] as String,
      closingTime: json['closing_time'] as String,
      isClosed: json['is_closed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barber_shop_id': barberShopId,
      'day_of_week': dayOfWeek,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'is_closed': isClosed,
    };
  }
}
