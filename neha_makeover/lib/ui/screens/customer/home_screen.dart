import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context),
            const SizedBox(height: 32),
            _buildTrustIndicators(context),
            const SizedBox(height: 48),
            _buildSectionTitle(context, 'Signature Services'),
            _buildSignatureServices(context),
            const SizedBox(height: 48),
            _buildSectionTitle(context, 'Why Women Choose Us'),
            _buildTrustSection(context),
            const SizedBox(height: 48),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Open AI Assistant
        },
        backgroundColor: AppTheme.roseGold,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Ask AI Concierge'),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: const BoxDecoration(
        color: AppTheme.champagne,
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1522337660859-02fbefca4702?q=80&w=2069&auto=format&fit=crop'), // Placeholder luxury image
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              'Your Personal\nBeauty Concierge',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'A private, premium, women-only experience.',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white.withAlpha(230),
                  ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Book Appointment'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text('Explore Portfolio'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustIndicators(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildTrustChip(Icons.star, '4.9/5 Rating'),
          _buildTrustChip(Icons.verified_user, 'Women-Only Salon'),
          _buildTrustChip(Icons.home, 'Home & Salon Service'),
        ],
      ),
    );
  }

  Widget _buildTrustChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, color: AppTheme.roseGold, size: 20),
      label: Text(label),
      backgroundColor: AppTheme.ivory,
      side: const BorderSide(color: AppTheme.mutedMauve, width: 0.5),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildSignatureServices(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    color: AppTheme.mutedMauve,
                    child: const Icon(Icons.image, color: Colors.white54, size: 40),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bridal Package ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          const Text('₹15,000 • 3 Hours', style: TextStyle(color: Colors.grey)),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft,
                            ),
                            child: const Text('Quick Book'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrustSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.blush.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            ListTile(
              leading: Icon(Icons.health_and_safety, color: AppTheme.deepPlum),
              title: Text('100% Hygienic & Safe'),
              subtitle: Text('Single-use tools and hospital-grade sanitization.'),
            ),
            ListTile(
              leading: Icon(Icons.schedule, color: AppTheme.deepPlum),
              title: Text('No Waiting Time'),
              subtitle: Text('We respect your time. Be seated the moment you arrive.'),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip, color: AppTheme.deepPlum),
              title: Text('Private Rooms'),
              subtitle: Text('Enjoy your services in absolute comfort and privacy.'),
            ),
          ],
        ),
      ),
    );
  }
}
