import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/navigation_providers.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/meme_generator/meme_generator_screen.dart';
import '../screens/saved_memes/saved_memes_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/auth_loading_screen.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _GoRouterRefreshNotifier();

  ref.listen(appNavigationStateProvider, (previous, next) {
    refreshNotifier.notify();
  });

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.root,
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final navState = ref.read(appNavigationStateProvider);
      final currentPath = state.matchedLocation;
      return navState.getRedirectPath(currentPath);
    },
    routes: [
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) => const AuthLoadingScreen(key: ValueKey('app_loading')),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.memeGenerator,
        builder: (context, state) => const MemeGeneratorScreen(),
      ),
      GoRoute(
        path: AppRoutes.savedMemes,
        builder: (context, state) => const SavedMemesScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Page not found', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(state.matchedLocation, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
});

class _GoRouterRefreshNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
