import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../theme/theme.dart';

class CustomerScaffold extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const CustomerScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<CustomerScaffold> createState() => _CustomerScaffoldState();
}

class _CustomerScaffoldState extends State<CustomerScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withAlpha(20),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: AppTheme.blush,
              hoverColor: AppTheme.blush,
              gap: 8,
              activeColor: AppTheme.deepPlum,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppTheme.champagne.withAlpha(150),
              color: AppTheme.mutedMauve,
              tabs: const [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.spa_outlined,
                  text: 'Services',
                ),
                GButton(
                  icon: Icons.photo_library_outlined,
                  text: 'Portfolio',
                ),
                GButton(
                  icon: Icons.calendar_today_outlined,
                  text: 'Book',
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'Profile',
                ),
              ],
              selectedIndex: widget.currentIndex,
              onTabChange: (index) {
                switch (index) {
                  case 0:
                    context.go('/');
                    break;
                  case 1:
                    context.go('/services');
                    break;
                  case 2:
                    context.go('/portfolio');
                    break;
                  case 3:
                    context.go('/book');
                    break;
                  case 4:
                    context.go('/profile');
                    break;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
