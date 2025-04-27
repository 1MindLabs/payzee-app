import 'package:go_router/go_router.dart';
import 'package:upi_pay/features/user/dashboard/presentation/screens/dashboard_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/user/dashboard',
  routes: [
    GoRoute(
      path: '/user/dashboard',
      builder: (context, state) => DashboardScreen(),
    ),
  ],
);
