import 'package:go_router/go_router.dart';

import '../../features/prayer/presentation/pages/tv_display_page.dart';

class AppRouter {
  AppRouter._();

  static const String initial = '/';

  static final GoRouter router = GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: initial,
        builder: (context, state) => const TVDisplayPage(),
      ),
    ],
    errorBuilder: (context, state) => const TVDisplayPage(),
  );
}
