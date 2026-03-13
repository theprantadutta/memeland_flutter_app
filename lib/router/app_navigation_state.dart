import 'route_names.dart';

class AppNavigationState {
  final bool isInitializing;
  final bool isAuthenticated;

  const AppNavigationState({
    this.isInitializing = true,
    this.isAuthenticated = false,
  });

  String? getRedirectPath(String currentPath) {
    if (isInitializing) {
      return null;
    }

    if (!isAuthenticated) {
      if (currentPath != AppRoutes.auth) {
        return AppRoutes.auth;
      }
      return null;
    }

    // Authenticated user at root or auth -> redirect to home
    if (currentPath == AppRoutes.root || currentPath == AppRoutes.auth) {
      return AppRoutes.home;
    }

    return null;
  }

  @override
  String toString() {
    return 'AppNavigationState(isInitializing: $isInitializing, isAuthenticated: $isAuthenticated)';
  }
}
