import 'package:get_it/get_it.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/data/datasources/barber_dashboard_remote_data_source.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/data/repositories/barber_dashboard_repository_impl.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/repositories/barber_dashboard_repository.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/usecases/get_daily_appointments.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/bloc/barber_dashboard_bloc.dart';

final GetIt sl = GetIt.instance;

/// Bağımlılık enjeksiyonu yapılandırması.
Future<void> initDependencies() async {
  // ==================== Barber Dashboard ====================
  // BLoC
  sl.registerFactory(
    () => BarberDashboardBloc(getDailyAppointments: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDailyAppointments(sl()));

  // Repository
  sl.registerLazySingleton<BarberDashboardRepository>(
    () => BarberDashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<BarberDashboardRemoteDataSource>(
    () => BarberDashboardRemoteDataSourceImpl(),
  );
}
