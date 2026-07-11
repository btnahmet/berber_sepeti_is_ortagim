import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:berber_sepeti_is_ortagim/core/di/injection_container.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/bloc/barber_dashboard_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/widgets/appointment_list_widget.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/widgets/dashboard_header_widget.dart';

/// Berber panosu ana sayfası.
class BarberDashboardPage extends StatelessWidget {
  const BarberDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BarberDashboardBloc>()
        ..add(LoadDailyAppointmentsEvent(
          barberId: 'current_barber_id', // TODO: Auth'dan alınacak
          date: DateTime.now(),
        )),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Randevu Panosu'),
        ),
        body: BlocBuilder<BarberDashboardBloc, BarberDashboardState>(
          builder: (context, state) {
            if (state is BarberDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BarberDashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BarberDashboardBloc>().add(
                              LoadDailyAppointmentsEvent(
                                barberId: 'current_barber_id',
                                date: DateTime.now(),
                              ),
                            );
                      },
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            }
            if (state is BarberDashboardLoaded) {
              return Column(
                children: [
                  DashboardHeaderWidget(selectedDate: state.selectedDate),
                  Expanded(
                    child: AppointmentListWidget(
                      appointments: state.appointments,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
