import 'package:go_router/go_router.dart';
import 'package:upi_pay/features/auth/login_screen.dart';
import 'package:upi_pay/features/user/dashboard/presentation/screens/dashboard_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/user/dashboard',
      builder: (context, state) => DashboardScreen(),
    ),
  ],
);
