part of 'working_hours_bloc.dart';

abstract class WorkingHoursState extends Equatable {
  const WorkingHoursState();
  
  @override
  List<Object> get props => [];
}

class WorkingHoursInitial extends WorkingHoursState {}

class WorkingHoursLoading extends WorkingHoursState {}

class WorkingHoursLoaded extends WorkingHoursState {
  final List<WorkingHours> workingHours;

  const WorkingHoursLoaded({required this.workingHours});

  @override
  List<Object> get props => [workingHours];
}

class WorkingHoursError extends WorkingHoursState {
  final String message;

  const WorkingHoursError({required this.message});

  @override
  List<Object> get props => [message];
}

class WorkingHoursActionSuccess extends WorkingHoursState {
  final String message;

  const WorkingHoursActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
