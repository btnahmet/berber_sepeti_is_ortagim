import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/entities/service.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/usecases/add_update_service.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/usecases/delete_service.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/usecases/get_services.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final GetServices getServices;
  final AddService addService;
  final UpdateService updateService;
  final DeleteService deleteService;

  ServicesBloc({
    required this.getServices,
    required this.addService,
    required this.updateService,
    required this.deleteService,
  }) : super(ServicesInitial()) {
    on<LoadServicesEvent>(_onLoadServices);
    on<AddServiceEvent>(_onAddService);
    on<UpdateServiceEvent>(_onUpdateService);
    on<DeleteServiceEvent>(_onDeleteService);
  }

  Future<void> _onLoadServices(
    LoadServicesEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    final result = await getServices(GetServicesParams(barberShopId: event.barberShopId));
    result.fold(
      (failure) => emit(ServicesError(message: failure.message)),
      (services) => emit(ServicesLoaded(services: services)),
    );
  }

  Future<void> _onAddService(
    AddServiceEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    final result = await addService(ServiceParams(service: event.service));
    result.fold(
      (failure) => emit(ServicesError(message: failure.message)),
      (_) {
        emit(const ServiceActionSuccess(message: 'Hizmet başarıyla eklendi.'));
        add(LoadServicesEvent(barberShopId: event.service.barberShopId));
      },
    );
  }

  Future<void> _onUpdateService(
    UpdateServiceEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    final result = await updateService(ServiceParams(service: event.service));
    result.fold(
      (failure) => emit(ServicesError(message: failure.message)),
      (_) {
        emit(const ServiceActionSuccess(message: 'Hizmet güncellendi.'));
        add(LoadServicesEvent(barberShopId: event.service.barberShopId));
      },
    );
  }

  Future<void> _onDeleteService(
    DeleteServiceEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    final result = await deleteService(DeleteServiceParams(serviceId: event.serviceId));
    result.fold(
      (failure) => emit(ServicesError(message: failure.message)),
      (_) {
        emit(const ServiceActionSuccess(message: 'Hizmet silindi.'));
        add(LoadServicesEvent(barberShopId: event.barberShopId));
      },
    );
  }
}
