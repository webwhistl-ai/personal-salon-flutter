import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services & Packages'),
        backgroundColor: AppTheme.ivory,
        surfaceTintColor: Colors.transparent,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar categories for larger screens, top tabs for mobile (simulated with standard list for now)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildServiceCategoryGroup(context, index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10, offset: const Offset(0, -2))
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('2 Services Selected', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Est. ₹4,500 • 90 mins', style: TextStyle(color: Colors.grey)),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Proceed to book
                },
                child: const Text('Continue to Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCategoryGroup(BuildContext context, int index) {
    final categories = ['Facials', 'Hair Care', 'Waxing', 'Nails', 'Bridal', 'Add-ons'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            categories[index],
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        ...List.generate(3, (i) => _buildServiceCard(context, categories[index], i)),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, String category, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Premium $category Treatment ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Deep cleanse, exfoliation, and luxury mask.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('₹1,500', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.deepPlum)),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text('45 mins', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    _showServiceDetails(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(0, 0),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.mutedMauve,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Icon(Icons.spa, size: 64, color: Colors.white)),
                ),
                const SizedBox(height: 24),
                Text('Premium Treatment', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                const Text('₹1,500 • 45 mins', style: TextStyle(fontSize: 16, color: AppTheme.deepPlum, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                const Text('What is included:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('• 10 minute consultation\n• Double cleanse\n• Extraction\n• Custom luxury mask\n• Shoulder massage'),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Add to Booking'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
