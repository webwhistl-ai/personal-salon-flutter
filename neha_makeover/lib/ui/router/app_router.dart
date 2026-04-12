import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/customer_scaffold.dart';

import '../screens/customer/home_screen.dart';
import '../screens/customer/services_screen.dart';
import '../screens/customer/portfolio_screen.dart';
import '../screens/customer/book_screen.dart';
import '../screens/customer/profile_screen.dart';
import '../screens/admin/admin_layout.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
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
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServicesScreen(),
        ),
        GoRoute(
          path: '/portfolio',
          builder: (context, state) => const PortfolioScreen(),
        ),
        GoRoute(
          path: '/book',
          builder: (context, state) => const BookScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminLayout(child: SizedBox()),
    ),
  ],
);
