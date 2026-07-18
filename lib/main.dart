import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart'; // EKLENDİ
import 'package:berber_sepeti_is_ortagim/core/constants/supabase_constants.dart';
import 'package:berber_sepeti_is_ortagim/core/di/injection_container.dart';
import 'package:berber_sepeti_is_ortagim/core/router/app_router.dart';
import 'package:berber_sepeti_is_ortagim/core/theme/app_theme.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/services/presentation/bloc/services_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/presentation/bloc/working_hours_bloc.dart'; // EKLENDİ

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('tr_TR', null); // EKLENDİ

  // Supabase bağlantısını başlat
  await Supabase.initialize(
    url: SupabaseConstants.projectUrl,
    anonKey: SupabaseConstants.anonKey,
  );

  await initDependencies();

  runApp(const BerberSepetiIsOrtagimApp());
}


class BerberSepetiIsOrtagimApp extends StatelessWidget {
  const BerberSepetiIsOrtagimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider<ServicesBloc>(
          create: (_) => sl<ServicesBloc>(),
        ),
        BlocProvider<WorkingHoursBloc>(
          create: (_) => sl<WorkingHoursBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Berber Sepeti İş Ortağım',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
