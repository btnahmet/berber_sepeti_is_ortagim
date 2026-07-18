import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/bloc/barber_dashboard_bloc.dart';

class AppointmentCardWidget extends StatelessWidget {
  final Appointment appointment;
  final DateTime selectedDate;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    required this.selectedDate,
  });

  Color _getStatusColor() {
    switch (appointment.status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.rejected:
      case AppointmentStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText() {
    switch (appointment.status) {
      case AppointmentStatus.pending:
        return 'Beklemede';
      case AppointmentStatus.confirmed:
        return 'Onaylandı';
      case AppointmentStatus.completed:
        return 'Tamamlandı';
      case AppointmentStatus.rejected:
        return 'Reddedildi';
      case AppointmentStatus.cancelled:
        return 'İptal Edildi';
    }
  }

  Future<void> _callCustomer(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _showRejectDialog(BuildContext context, String barberShopId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Randevuyu Reddet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Randevuyu iptal etmek için bir sebep girin (isteğe bağlı):'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Örn: Dükkan dolu',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BarberDashboardBloc>().add(
                    UpdateAppointmentStatusEvent(
                      appointmentId: appointment.id,
                      status: AppointmentStatus.rejected,
                      notes: reasonController.text.trim(),
                      barberShopId: barberShopId,
                      selectedDate: selectedDate,
                    ),
                  );
            },
            child: const Text('Reddet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String barberShopId = '';
    if (authState is Authenticated) {
      barberShopId = authState.user.barberShopId ?? '';
    }

    final timeFormat = DateFormat('HH:mm');
    final startTime = timeFormat.format(appointment.appointmentDate);
    final endTime = timeFormat.format(
      appointment.appointmentDate.add(Duration(minutes: appointment.serviceDurationMinutes)),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _getStatusColor().withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Kısım: Saat ve Durum
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(
                      '$startTime - $endTime',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatusColor()),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Orta Kısım: Müşteri ve Hizmet Detayları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.customerName ?? 'İsimsiz Müşteri',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.serviceName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${appointment.servicePrice.toStringAsFixed(2)} ₺',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            
            // Opsiyonel Not Gösterimi
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.note, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.notes!,
                        style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              )
            ],

            // Alt Kısım: Aksiyon Butonları (Duruma Göre Değişir)
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // İletişim Butonu (Örnek numara, gerçekte veritabanında olmalı)
                // Şimdilik pasif veya test amaçlı bırakabiliriz.
                /* IconButton(
                  icon: const Icon(Icons.phone, color: Colors.blue),
                  onPressed: () => _callCustomer('+905555555555'),
                ), */
                const Spacer(),
                
                // Beklemede ise Onayla ve Reddet
                if (appointment.status == AppointmentStatus.pending) ...[
                  OutlinedButton(
                    onPressed: () => _showRejectDialog(context, barberShopId),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Reddet'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BarberDashboardBloc>().add(
                            UpdateAppointmentStatusEvent(
                              appointmentId: appointment.id,
                              status: AppointmentStatus.confirmed,
                              barberShopId: barberShopId,
                              selectedDate: selectedDate,
                            ),
                          );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Onayla', style: TextStyle(color: Colors.white)),
                  ),
                ],

                // Onaylandıysa Tamamla
                if (appointment.status == AppointmentStatus.confirmed) ...[
                  ElevatedButton(
                    onPressed: () {
                      context.read<BarberDashboardBloc>().add(
                            UpdateAppointmentStatusEvent(
                              appointmentId: appointment.id,
                              status: AppointmentStatus.completed,
                              barberShopId: barberShopId,
                              selectedDate: selectedDate,
                            ),
                          );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('İşlemi Tamamla', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
