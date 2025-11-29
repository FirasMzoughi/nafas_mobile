import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nafas/features/auth/presentation/auth_screen.dart';
import 'package:nafas/features/home/presentation/home_screen.dart';
import 'package:nafas/features/home/domain/room.dart';
import 'package:nafas/features/home/presentation/room_detail_screen.dart';
import 'package:nafas/features/home/presentation/widgets/scaffold_with_nav_bar.dart';
import 'package:nafas/features/onboarding/presentation/onboarding_screen.dart';
import 'package:nafas/features/onboarding/presentation/splash_screen.dart';
import 'package:nafas/features/profile/presentation/profile_screen.dart';
import 'package:nafas/features/stories/presentation/stories_screen.dart';
import 'package:nafas/features/tools/presentation/screens/tools_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'room/:id',
                  parentNavigatorKey: _rootNavigatorKey, // Open full screen (hide bottom nav)
                  builder: (context, state) {
                    final room = state.extra as Room; // Pass room object
                    return RoomDetailScreen(room: room);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stories',
              builder: (context, state) => const StoriesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tools',
              builder: (context, state) => const ToolsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
