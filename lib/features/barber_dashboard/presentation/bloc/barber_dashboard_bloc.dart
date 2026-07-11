import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/usecases/get_daily_appointments.dart';

part 'barber_dashboard_event.dart';
part 'barber_dashboard_state.dart';

/// Berber panosu BLoC - iş mantığı bileşeni.
class BarberDashboardBloc
    extends Bloc<BarberDashboardEvent, BarberDashboardState> {
  final GetDailyAppointments getDailyAppointments;

  BarberDashboardBloc({required this.getDailyAppointments})
      : super(BarberDashboardInitial()) {
    on<LoadDailyAppointmentsEvent>(_onLoadDailyAppointments);
    on<ChangeDateEvent>(_onChangeDate);
  }

  Future<void> _onLoadDailyAppointments(
    LoadDailyAppointmentsEvent event,
    Emitter<BarberDashboardState> emit,
  ) async {
    emit(BarberDashboardLoading());

    final result = await getDailyAppointments(
      GetDailyAppointmentsParams(
        barberId: event.barberId,
        date: event.date,
      ),
    );

    result.fold(
      (failure) => emit(BarberDashboardError(message: failure.message)),
      (appointments) => emit(BarberDashboardLoaded(
        appointments: appointments,
        selectedDate: event.date,
      )),
    );
  }

  Future<void> _onChangeDate(
    ChangeDateEvent event,
    Emitter<BarberDashboardState> emit,
  ) async {
    // TODO: barberId'yi auth'dan al
    add(LoadDailyAppointmentsEvent(
      barberId: 'current_barber_id',
      date: event.newDate,
    ));
  }
}
