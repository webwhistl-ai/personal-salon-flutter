import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/customer_scaffold.dart';

import '../screens/customer/home_screen.dart';
import '../screens/customer/services_screen.dart';
import '../screens/customer/portfolio_screen.dart';
import '../screens/customer/book_screen.dart';
import '../screens/customer/profile_screen.dart';
import '../screens/admin/admin_layout.dart';
import '../screens/auth/login_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/', // Start at home, do not force login
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        int currentIndex = 0;
        if (state.uri.path.startsWith('/services')) currentIndex = 1;
        if (state.uri.path.startsWith('/portfolio')) currentIndex = 2;
        if (state.uri.path.startsWith('/book')) currentIndex = 3;
        if (state.uri.path.startsWith('/profile')) currentIndex = 4;

        return CustomerScaffold(
          currentIndex: currentIndex,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/services',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ServicesScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/portfolio',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const PortfolioScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/book',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const BookScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ProfileScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminLayout(child: SizedBox()),
    ),
  ],
);
