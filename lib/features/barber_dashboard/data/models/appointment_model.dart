import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';

/// Randevu veri modeli - Supabase JSON dönüşümlerini yönetir.
/// Sütun adları mevcut veritabanı şemasına uygun olarak eşlenir.
class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.barberShopId,
    required super.barberShopName,
    super.userId,
    super.customerName,
    super.serviceId,
    required super.serviceName,
    required super.servicePrice,
    required super.appointmentDate,
    required super.serviceDurationMinutes,
    required super.status,
    super.notes,
    super.createdAt,
  });

  /// Supabase'den gelen JSON verisini modele dönüştürür.
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      barberShopId: json['barber_shop_id'] as String,
      barberShopName: json['barber_shop_name'] as String? ?? '',
      userId: json['user_id'] as String?,
      customerName: json['customer_name'] as String?,
      serviceId: json['service_id'] as String?,
      serviceName: json['service_name'] as String? ?? 'Belirtilmemiş',
      servicePrice: (json['service_price'] as num?)?.toDouble() ?? 0.0,
      appointmentDate: DateTime.parse(json['appointment_date'] as String),
      serviceDurationMinutes: json['service_duration_minutes'] as int? ?? 30,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'pending'),
        orElse: () => AppointmentStatus.pending,
      ),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barber_shop_id': barberShopId,
      'barber_shop_name': barberShopName,
      'user_id': userId,
      'customer_name': customerName,
      'service_id': serviceId,
      'service_name': serviceName,
      'service_price': servicePrice,
      'service_duration_minutes': serviceDurationMinutes,
      'appointment_date': appointmentDate.toIso8601String(),
      'status': status.name,
      'notes': notes,
    };
  }
}
