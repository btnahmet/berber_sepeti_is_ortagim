import 'package:flutter/material.dart';
import 'package:berber_sepeti_is_ortagim/core/di/injection_container.dart';
import 'package:berber_sepeti_is_ortagim/core/router/app_router.dart';
import 'package:berber_sepeti_is_ortagim/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Supabase.initialize() burada çağrılacak
  // await Supabase.initialize(
  //   url: 'YOUR_SUPABASE_URL',
  //   anonKey: 'YOUR_SUPABASE_ANON_KEY',
  // );

  await initDependencies();

  runApp(const BerberSepetiIsOrtagimApp());
}

class BerberSepetiIsOrtagimApp extends StatelessWidget {
  const BerberSepetiIsOrtagimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Berber Sepeti İş Ortağım',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
