import 'package:go_router/go_router.dart';
import 'package:berber_sepeti_is_ortagim/core/presentation/pages/main_page.dart'; // EKLENDİ
import 'package:berber_sepeti_is_ortagim/features/auth/presentation/pages/splash_page.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/presentation/pages/login_page.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/presentation/pages/register_page.dart';

/// Uygulama yönlendirme yapılandırması.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const MainPage(), // DEĞİŞTİRİLDİ
      ),
    ],
  );
}
