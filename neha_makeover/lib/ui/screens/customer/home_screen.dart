import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../../providers/service_provider.dart';
import '../../widgets/assistant_widget.dart';

class _AssistantWrapper extends StatelessWidget {
  const _AssistantWrapper();

  @override
  Widget build(BuildContext context) {
    return const AssistantWidget();
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

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
            servicesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error loading services: $e')),
              data: (services) {
                final popularServices = services.where((s) => s.isPopular).toList();
                if (popularServices.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text('No signature services found at the moment.', style: TextStyle(color: Colors.grey)),
                  );
                }
                return _buildSignatureServices(context, popularServices);
              },
            ),
            const SizedBox(height: 48),
            _buildSectionTitle(context, 'Why Women Choose Us'),
            _buildTrustSection(context),
            const SizedBox(height: 48),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: _AssistantWrapper(), // Custom wrapper to avoid import cycles if needed, or direct import
                ),
              ),
            ),
          );
        },
        backgroundColor: AppTheme.roseGold,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Ask AI Concierge'),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Hero(
      tag: 'home_hero',
      child: Container(
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
                      height: 1.2,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'A private, premium, women-only experience.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white.withAlpha(230),
                      fontSize: 18,
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

  Widget _buildSignatureServices(BuildContext context, List popularServices) {
    return SizedBox(
      height: 290, // Slightly taller to accommodate shadow space
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: popularServices.length,
        itemBuilder: (context, index) {
          final service = popularServices[index];
          return Container(
            width: 220,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15), // softer, lighter shadow
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (service.imageUrl.isNotEmpty)
                    Image.network(service.imageUrl, height: 130, width: double.infinity, fit: BoxFit.cover)
                  else
                    Container(
                      height: 130,
                      width: double.infinity,
                      color: AppTheme.mutedMauve.withAlpha(100),
                      child: const Icon(Icons.spa, color: Colors.white54, size: 40),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Text('₹${service.price.toStringAsFixed(0)} • ${service.durationMinutes} mins', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                side: const BorderSide(color: AppTheme.roseGold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                minimumSize: const Size(0, 36),
                              ),
                              child: const Text('Quick Book', style: TextStyle(fontSize: 13, color: AppTheme.deepPlum)),
                            ),
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
