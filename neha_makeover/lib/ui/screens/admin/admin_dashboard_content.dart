import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/theme.dart';
import '../../../core/utils/firebase_seeder.dart';

class AdminDashboardContent extends StatefulWidget {
  const AdminDashboardContent({super.key});

  @override
  State<AdminDashboardContent> createState() => _AdminDashboardContentState();
}

class _AdminDashboardContentState extends State<AdminDashboardContent> {
  bool _isSeeding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Overview'),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton.icon(
              onPressed: _isSeeding ? null : () async {
                setState(() => _isSeeding = true);
                print('AdminDashboard: Seed button pressed. State set to loading.');
                try {
                  await FirebaseSeeder().seedDatabase().timeout(const Duration(seconds: 30), onTimeout: () {
                    throw Exception("Firestore database seed timed out. Check your Firebase Database Rules or network connection.");
                  });
                  print('AdminDashboard: Seed successful.');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database seeded successfully!')));
                  }
                } catch (e, stack) {
                  print('AdminDashboard: Seed failed: $e\n$stack');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Failed to seed: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 5),
                    ));
                  }
                } finally {
                  print('AdminDashboard: Restoring button state.');
                  if (mounted) {
                    setState(() => _isSeeding = false);
                  }
                }
              },
              icon: _isSeeding ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.download),
              label: const Text('Seed Demo Data'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards
            Row(
              children: [
                Expanded(child: _buildKpiCard('Today\'s Bookings', '12', Icons.calendar_today, Colors.blue)),
                const SizedBox(width: 16),
                Expanded(child: _buildKpiCard('Revenue (Today)', '₹24,500', Icons.currency_rupee, Colors.green)),
                const SizedBox(width: 16),
                Expanded(child: _buildKpiCard('Pending Requests', '5', Icons.pending_actions, Colors.orange)),
                const SizedBox(width: 16),
                Expanded(child: _buildKpiCard('Active Staff', '4/6', Icons.people, AppTheme.deepPlum)),
              ],
            ),
            const SizedBox(height: 32),
            // Charts Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Revenue (Last 7 Days)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 300,
                            child: BarChart(
                              BarChartData(
                                barGroups: [
                                  _makeGroupData(0, 5),
                                  _makeGroupData(1, 6.5),
                                  _makeGroupData(2, 5),
                                  _makeGroupData(3, 7.5),
                                  _makeGroupData(4, 9),
                                  _makeGroupData(5, 11.5),
                                  _makeGroupData(6, 6),
                                ],
                                borderData: FlBorderData(show: false),
                                gridData: const FlGridData(show: false),
                                titlesData: const FlTitlesData(
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 16),
                          _buildActivityItem('New booking: Bridal Makeup', '2 mins ago'),
                          _buildActivityItem('Payment received: ₹4,500', '15 mins ago'),
                          _buildActivityItem('Booking rescheduled by Sarah', '1 hour ago'),
                          _buildActivityItem('New review (5 stars)', '3 hours ago'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppTheme.roseGold,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.deepPlum),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontSize: 14)),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
