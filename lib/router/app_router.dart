import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/views/login_screen.dart';
import '../features/auth/views/splash_screen.dart';
import '../features/home/views/home_screen.dart';
import '../features/history/views/history_screen.dart';
import '../features/onboarding/views/preferences_step_screen.dart';
import '../features/onboarding/views/profile_step_screen.dart';
import '../features/settings/views/settings_screen.dart';
import '../features/workouts/views/workout_detail_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: SplashScreen.path,
    refreshListenable: notifier,
    redirect: notifier.handleRedirect,
    routes: [
      GoRoute(
        path: SplashScreen.path,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.path,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: ProfileStepScreen.path,
        builder: (_, __) => const ProfileStepScreen(),
      ),
      GoRoute(
        path: PreferencesStepScreen.path,
        builder: (_, __) => const PreferencesStepScreen(),
      ),
      GoRoute(
        path: HomeScreen.path,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: HistoryScreen.path,
        builder: (_, __) => const HistoryScreen(),
      ),
      GoRoute(
        path: SettingsScreen.path,
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/workouts/:id',
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const Scaffold(body: Center(child: Text('Workout not found')));
          }
          return WorkoutDetailScreen(workoutId: id);
        },
      ),
    ],
  );
});

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this.ref) {
    ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }

  final Ref ref;

  FutureOr<String?> handleRedirect(BuildContext context, GoRouterState state) {
    final authAsync = ref.read(authControllerProvider);

    final loggingIn = state.matchedLocation == LoginScreen.path;
    final onboardingPath = state.matchedLocation.startsWith('/onboarding');
    final onSplash = state.matchedLocation == SplashScreen.path;

    if (authAsync.isLoading) {
      return onSplash ? null : SplashScreen.path;
    }

    final authState = authAsync.value ?? const AuthState.signedOut();

    if (!authState.isAuthenticated) {
      return loggingIn ? null : LoginScreen.path;
    }

    if (authState.requiresOnboarding && !onboardingPath) {
      return ProfileStepScreen.path;
    }

    if (!authState.requiresOnboarding && onboardingPath) {
      return HomeScreen.path;
    }

    if (onSplash || loggingIn) {
      return HomeScreen.path;
    }

    return null;
  }
}
