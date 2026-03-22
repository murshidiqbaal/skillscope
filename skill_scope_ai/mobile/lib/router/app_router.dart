import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:mobile/features/auth/screens/login_screen.dart';
import 'package:mobile/features/chatbot/screens/chatbot_screen.dart';
import 'package:mobile/features/profile/data/models/profile_model.dart';
import 'package:mobile/features/profile/presentation/edit_profile_screen.dart';
import 'package:mobile/features/profile/presentation/provider/profile_provider.dart';
import 'package:mobile/features/profile/screens/profile_screen.dart';
import 'package:mobile/features/resume_validator/screens/resume_validator_screen.dart';
import 'package:mobile/features/trending_skills/screens/trending_skills_screen.dart';
import 'package:mobile/shared/splash_screen.dart';

/// Custom Listenable that notifies GoRouter when to re-evaluate the redirect logic
class AppRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  AppRouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
    _ref.listen(currentProfileProvider, (_, __) => notifyListeners());
  }
}

/// GoRouter provider for app navigation
final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = AppRouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);

      if (authState.isLoading) return null;

      final session = authState.value?.session;
      final isAuthenticated = session != null;
      final matchedLocation = state.matchedLocation;

      // Allow splash screen to finish
      if (matchedLocation == '/splash') return null;

      if (!isAuthenticated) {
        return matchedLocation == '/login' ? null : '/login';
      }

      // If authenticated, check for profile
      final profileAsync = ref.read(currentProfileProvider);

      // Still loading profile data - don't redirect yet to avoid flicker
      if (profileAsync.isLoading) return null;

      final hasProfile = profileAsync.value != null;

      // If on login, redirect home since user is authenticated
      if (matchedLocation == '/login') {
        return '/';
      }

      // User has profile. If on create_profile, redirect home
      if (hasProfile && matchedLocation == '/create_profile') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => VibrantSplashScreen(
          onSplashComplete: () {
            context.go('/');
          },
        ),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const _MainScaffold(child: TrendingSkillsScreen(), currentIndex: 0),
      ),
      GoRoute(
        path: '/resume_validator',
        builder: (context, state) => const _MainScaffold(
          child: ResumeValidatorScreen(),
          currentIndex: 1,
        ),
      ),
      GoRoute(
        path: '/chatbot',
        builder: (context, state) =>
            const _MainScaffold(child: ChatbotScreen(), currentIndex: 2),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) =>
            const _MainScaffold(child: ProfileScreen(), currentIndex: 3),
      ),
      // GoRoute(
      //   path: '/create_profile',
      //   builder: (context, state) =>
      //       const _MainScaffold(child: CreateProfileScreen(), currentIndex: 3),
      // ),
      GoRoute(
        path: '/edit_profile',
        builder: (context, state) => _MainScaffold(
          child: EditProfileScreen(profile: state.extra as Profile),
          currentIndex: 3,
        ),
      ),
    ],
  );
});

/// Scaffold wrapper to maintain Bottom Navigation across routes
class _MainScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const _MainScaffold({required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.primaryContainer,
        buttonBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          if (index == currentIndex) return;
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/resume_validator');
              break;
            case 2:
              context.go('/chatbot');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        items: [
          Icon(
            Icons.trending_up,
            size: 30,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          Icon(
            Icons.document_scanner,
            size: 30,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          Icon(
            Icons.chat,
            size: 30,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ],
      ),
    );
  }
}
