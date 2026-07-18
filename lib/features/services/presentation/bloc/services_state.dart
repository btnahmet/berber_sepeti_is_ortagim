part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();
  
  @override
  List<Object> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<Service> services;

  const ServicesLoaded({required this.services});

  @override
  List<Object> get props => [services];
}

class ServicesError extends ServicesState {
  final String message;

  const ServicesError({required this.message});

  @override
  List<Object> get props => [message];
}

// Yeni servis ekleme/güncelleme/silme başarılı olduğunda gösterilecek geçici state
class ServiceActionSuccess extends ServicesState {
  final String message;

  const ServiceActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
