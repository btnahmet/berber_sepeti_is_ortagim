import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/usecases/create_appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/usecases/get_daily_appointments.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/usecases/update_appointment_status.dart';

part 'barber_dashboard_event.dart';
part 'barber_dashboard_state.dart';

/// Berber panosu BLoC - iş mantığı bileşeni.
class BarberDashboardBloc
    extends Bloc<BarberDashboardEvent, BarberDashboardState> {
  final GetDailyAppointments getDailyAppointments;
  final UpdateAppointmentStatus updateAppointmentStatus;
  final CreateAppointment createAppointment;

  BarberDashboardBloc({
    required this.getDailyAppointments,
    required this.updateAppointmentStatus,
    required this.createAppointment,
  }) : super(BarberDashboardInitial()) {
    on<LoadDailyAppointmentsEvent>(_onLoadDailyAppointments);
    on<ChangeDateEvent>(_onChangeDate);
    on<UpdateAppointmentStatusEvent>(_onUpdateAppointmentStatus);
    on<CreateAppointmentEvent>(_onCreateAppointment);
  }

  Future<void> _onLoadDailyAppointments(
    LoadDailyAppointmentsEvent event,
    Emitter<BarberDashboardState> emit,
  ) async {
    emit(BarberDashboardLoading());

    final result = await getDailyAppointments(
      GetDailyAppointmentsParams(
        barberShopId: event.barberShopId,
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

  Future<void> _onUpdateAppointmentStatus(
    UpdateAppointmentStatusEvent event,
    Emitter<BarberDashboardState> emit,
  ) async {
    emit(BarberDashboardLoading());

    final result = await updateAppointmentStatus(
      UpdateAppointmentStatusParams(
        appointmentId: event.appointmentId,
        status: event.status,
        notes: event.notes,
      ),
    );

    result.fold(
      (failure) => emit(BarberDashboardError(message: failure.message)),
      (_) {
        add(LoadDailyAppointmentsEvent(
          barberShopId: event.barberShopId,
          date: event.selectedDate,
        ));
      },
    );
  }

  Future<void> _onCreateAppointment(
    CreateAppointmentEvent event,
    Emitter<BarberDashboardState> emit,
  ) async {
    emit(BarberDashboardLoading());

    final result = await createAppointment(
      CreateAppointmentParams(appointment: event.appointment),
    );

    result.fold(
      (failure) => emit(BarberDashboardError(message: failure.message)),
      (_) {
        add(LoadDailyAppointmentsEvent(
          barberShopId: event.barberShopId,
          date: event.selectedDate,
        ));
      },
    );
  }

  Future<void> _onChangeDate(
    ChangeDateEvent event,
    Emitter<BarberDashboardState> emit,
  ) async {
    // TODO: barberShopId'yi auth'dan al
    add(LoadDailyAppointmentsEvent(
      barberShopId: 'current_barber_shop_id',
      date: event.newDate,
    ));
  }
}
