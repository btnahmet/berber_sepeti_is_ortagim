import 'package:get_it/get_it.dart';

// Barber Dashboard Imports
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/data/datasources/barber_dashboard_remote_data_source.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/data/repositories/barber_dashboard_repository_impl.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/repositories/barber_dashboard_repository.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/usecases/create_appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/usecases/get_daily_appointments.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/usecases/update_appointment_status.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/bloc/barber_dashboard_bloc.dart';

// Services Imports
import 'package:berber_sepeti_is_ortagim/features/services/data/datasources/services_remote_data_source.dart';
import 'package:berber_sepeti_is_ortagim/features/services/data/repositories/services_repository_impl.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/repositories/services_repository.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/usecases/add_update_service.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/usecases/delete_service.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/usecases/get_services.dart';
import 'package:berber_sepeti_is_ortagim/features/services/presentation/bloc/services_bloc.dart';

// Working Hours Imports
import 'package:berber_sepeti_is_ortagim/features/working_hours/data/datasources/working_hours_remote_data_source.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/data/repositories/working_hours_repository_impl.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/repositories/working_hours_repository.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/usecases/get_working_hours.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/usecases/update_working_hours.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/presentation/bloc/working_hours_bloc.dart';

// Auth Imports
import 'package:berber_sepeti_is_ortagim/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/repositories/auth_repository.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/usecases/login_usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/usecases/logout_usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/domain/usecases/register_usecase.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/presentation/bloc/auth_bloc.dart';

final GetIt sl = GetIt.instance;

/// Bağımlılık enjeksiyonu yapılandırması.
Future<void> initDependencies() async {
  // ==========================================
  // AUTHENTICATION FEATURE
  // ==========================================
  
  // BLoC
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // ==========================================
  // BARBER DASHBOARD FEATURE
  // ==========================================

  // BLoC
  sl.registerFactory(() => BarberDashboardBloc(
        getDailyAppointments: sl(),
        updateAppointmentStatus: sl(),
        createAppointment: sl(), // EKLENDİ
      ));

  // Use cases
  sl.registerLazySingleton(() => GetDailyAppointments(sl()));
  sl.registerLazySingleton(() => UpdateAppointmentStatus(sl()));
  sl.registerLazySingleton(() => CreateAppointment(sl())); // EKLENDİ

  // Repository
  sl.registerLazySingleton<BarberDashboardRepository>(
    () => BarberDashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<BarberDashboardRemoteDataSource>(
    () => BarberDashboardRemoteDataSourceImpl(),
  );

  // ==========================================
  // SERVICES FEATURE
  // ==========================================

  // BLoC
  sl.registerFactory(() => ServicesBloc(
        getServices: sl(),
        addService: sl(),
        updateService: sl(),
        deleteService: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetServices(sl()));
  sl.registerLazySingleton(() => AddService(sl()));
  sl.registerLazySingleton(() => UpdateService(sl()));
  sl.registerLazySingleton(() => DeleteService(sl()));

  // Repository
  sl.registerLazySingleton<ServicesRepository>(
    () => ServicesRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ServicesRemoteDataSource>(
    () => ServicesRemoteDataSourceImpl(),
  );
  // ==========================================
  // WORKING HOURS FEATURE
  // ==========================================

  // BLoC
  sl.registerFactory(() => WorkingHoursBloc(
        getWorkingHours: sl(),
        updateWorkingHours: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetWorkingHours(sl()));
  sl.registerLazySingleton(() => UpdateWorkingHours(sl()));

  // Repository
  sl.registerLazySingleton<WorkingHoursRepository>(
    () => WorkingHoursRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WorkingHoursRemoteDataSource>(
    () => WorkingHoursRemoteDataSourceImpl(),
  );
}
