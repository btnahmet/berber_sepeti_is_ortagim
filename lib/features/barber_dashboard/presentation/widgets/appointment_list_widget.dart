import 'package:flutter/material.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/widgets/appointment_card_widget.dart';

/// Randevu listesi widget'ı.
class AppointmentListWidget extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentListWidget({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Bugün için randevu bulunmuyor',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCardWidget(appointment: appointments[index]);
      },
    );
  }
}
