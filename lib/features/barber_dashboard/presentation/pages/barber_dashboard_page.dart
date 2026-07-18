import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:berber_sepeti_is_ortagim/core/di/injection_container.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/bloc/barber_dashboard_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/pages/add_appointment_page.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/widgets/appointment_list_widget.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/widgets/dashboard_header_widget.dart';

/// Berber panosu ana sayfası.
class BarberDashboardPage extends StatelessWidget {
  const BarberDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String barberShopId = 'unknown';
    
    if (authState is Authenticated) {
      barberShopId = authState.user.barberShopId ?? 'unknown';
    }

    return BlocProvider(
      create: (_) => sl<BarberDashboardBloc>()
        ..add(LoadDailyAppointmentsEvent(
          barberShopId: barberShopId,
          date: DateTime.now(),
        )),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Randevu Panosu'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequestedEvent());
              },
            ),
          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              // AppRouter'daki redirect mantığı da bunu halleder ama ekstra güvenlik için buraya eklenebilir.
            }
          },
          child: BlocBuilder<BarberDashboardBloc, BarberDashboardState>(
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
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<BarberDashboardBloc>().add(
                                LoadDailyAppointmentsEvent(
                                  barberShopId: barberShopId,
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
                        selectedDate: state.selectedDate,
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text('Bilinmeyen durum'));
            },
          ),
        ),
        floatingActionButton: BlocBuilder<BarberDashboardBloc, BarberDashboardState>(
          builder: (context, state) {
            DateTime selectedDate = DateTime.now();
            if (state is BarberDashboardLoaded) {
              selectedDate = state.selectedDate;
            }
            return FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAppointmentPage(selectedDate: selectedDate),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Randevu Ekle'),
            );
          },
        ),
      ),
    );
  }
}
