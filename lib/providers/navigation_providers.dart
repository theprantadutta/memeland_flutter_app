import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/app_navigation_state.dart';
import 'app_providers.dart';

final appNavigationStateProvider = Provider<AppNavigationState>((ref) {
  final authState = ref.watch(backendAuthProvider);

  return AppNavigationState(
    isInitializing: authState.isInitializing,
    isAuthenticated: authState.isAuthenticated,
  );
});
