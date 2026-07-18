part of 'services_bloc.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => [];
}

class LoadServicesEvent extends ServicesEvent {
  final String barberShopId;

  const LoadServicesEvent({required this.barberShopId});

  @override
  List<Object> get props => [barberShopId];
}

class AddServiceEvent extends ServicesEvent {
  final Service service;

  const AddServiceEvent({required this.service});

  @override
  List<Object> get props => [service];
}

class UpdateServiceEvent extends ServicesEvent {
  final Service service;

  const UpdateServiceEvent({required this.service});

  @override
  List<Object> get props => [service];
}

class DeleteServiceEvent extends ServicesEvent {
  final String serviceId;
  final String barberShopId; // Listeyi tekrar yüklemek için

  const DeleteServiceEvent({
    required this.serviceId,
    required this.barberShopId,
  });

  @override
  List<Object> get props => [serviceId, barberShopId];
}
