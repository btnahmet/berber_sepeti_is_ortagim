import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/entities/working_hours.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/usecases/get_working_hours.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/usecases/update_working_hours.dart';

part 'working_hours_event.dart';
part 'working_hours_state.dart';

class WorkingHoursBloc extends Bloc<WorkingHoursEvent, WorkingHoursState> {
  final GetWorkingHours getWorkingHours;
  final UpdateWorkingHours updateWorkingHours;

  WorkingHoursBloc({
    required this.getWorkingHours,
    required this.updateWorkingHours,
  }) : super(WorkingHoursInitial()) {
    on<LoadWorkingHoursEvent>(_onLoadWorkingHours);
    on<SaveWorkingHoursEvent>(_onSaveWorkingHours);
  }

  Future<void> _onLoadWorkingHours(
    LoadWorkingHoursEvent event,
    Emitter<WorkingHoursState> emit,
  ) async {
    emit(WorkingHoursLoading());
    final result = await getWorkingHours(GetWorkingHoursParams(barberShopId: event.barberShopId));
    result.fold(
      (failure) => emit(WorkingHoursError(message: failure.message)),
      (hours) => emit(WorkingHoursLoaded(workingHours: hours)),
    );
  }

  Future<void> _onSaveWorkingHours(
    SaveWorkingHoursEvent event,
    Emitter<WorkingHoursState> emit,
  ) async {
    emit(WorkingHoursLoading());
    final result = await updateWorkingHours(UpdateWorkingHoursParams(workingHours: event.workingHours));
    result.fold(
      (failure) => emit(WorkingHoursError(message: failure.message)),
      (_) {
        emit(const WorkingHoursActionSuccess(message: 'Çalışma saatleri başarıyla kaydedildi.'));
        add(LoadWorkingHoursEvent(barberShopId: event.barberShopId));
      },
    );
  }
}
