import 'package:equatable/equatable.dart';

class WorkingHours extends Equatable {
  final String id;
  final String barberShopId;
  final int dayOfWeek; // 1 = Pazartesi, 7 = Pazar
  final String openingTime; // Örn: "09:00"
  final String closingTime; // Örn: "20:00"
  final bool isClosed;

  const WorkingHours({
    required this.id,
    required this.barberShopId,
    required this.dayOfWeek,
    required this.openingTime,
    required this.closingTime,
    required this.isClosed,
  });

  @override
  List<Object?> get props => [
        id,
        barberShopId,
        dayOfWeek,
        openingTime,
        closingTime,
        isClosed,
      ];
}
