import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'admin_dashboard_content.dart';
import 'admin_bookings_screen.dart';
import 'admin_services_screen.dart';
import 'admin_portfolio_screen.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;
  const AdminLayout({super.key, required this.child});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: AppTheme.darkCharcoal,
            unselectedIconTheme: const IconThemeData(color: Colors.white54),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white54),
            selectedIconTheme: const IconThemeData(color: AppTheme.roseGold),
            selectedLabelTextStyle: const TextStyle(color: AppTheme.roseGold),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
              NavigationRailDestination(icon: Icon(Icons.calendar_month), label: Text('Bookings')),
              NavigationRailDestination(icon: Icon(Icons.spa), label: Text('Services')),
              NavigationRailDestination(icon: Icon(Icons.photo_library), label: Text('Portfolio')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('Staff')),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
            ],
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 40),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main content
          Expanded(
            child: _getSelectedScreen(),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const AdminDashboardContent();
      case 1:
        return const AdminBookingsScreen();
      case 2:
        return const AdminServicesScreen();
      case 3:
        return const AdminPortfolioScreen();
      default:
        return const Center(child: Text('Under Construction'));
    }
  }
}
