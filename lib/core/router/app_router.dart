import 'package:go_router/go_router.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/pages/barber_dashboard_page.dart';

/// Uygulama yönlendirme yapılandırması.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const BarberDashboardPage(),
      ),
    ],
  );
}
