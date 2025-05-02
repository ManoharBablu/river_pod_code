import 'package:go_router/go_router.dart';
import 'package:sample_app/presentation/login_screen.dart';
import 'package:sample_app/presentation/product_screen.dart';

class AppRouter {
  GoRouter goRouter = GoRouter(initialLocation: '/login_screen', routes: [
    GoRoute(
      path: '/login_screen',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
        path: '/products_screen',
        builder: (context, state) {
          final token = state.extra as String;
          return ProductScreen(token);
        }),
  ]);
}
