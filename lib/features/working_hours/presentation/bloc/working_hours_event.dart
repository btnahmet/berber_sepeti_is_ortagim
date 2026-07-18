part of 'working_hours_bloc.dart';

abstract class WorkingHoursEvent extends Equatable {
  const WorkingHoursEvent();

  @override
  List<Object> get props => [];
}

class LoadWorkingHoursEvent extends WorkingHoursEvent {
  final String barberShopId;

  const LoadWorkingHoursEvent({required this.barberShopId});

  @override
  List<Object> get props => [barberShopId];
}

class SaveWorkingHoursEvent extends WorkingHoursEvent {
  final List<WorkingHours> workingHours;
  final String barberShopId;

  const SaveWorkingHoursEvent({
    required this.workingHours,
    required this.barberShopId,
  });

  @override
  List<Object> get props => [workingHours, barberShopId];
}
