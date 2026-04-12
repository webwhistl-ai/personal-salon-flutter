import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../../providers/service_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../models/service_model.dart';
import '../../../models/service_category.dart';
import '../../../providers/booking_flow_provider.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services & Packages'),
        backgroundColor: AppTheme.ivory,
        surfaceTintColor: Colors.transparent,
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.roseGold)),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories available.'));
          }

          return servicesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.roseGold)),
            error: (err, stack) => Center(child: Text('Error loading services: $err')),
            data: (services) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final categoryServices = services.where((s) => s.categoryId == category.id).toList();

                  if (categoryServices.isEmpty) return const SizedBox.shrink();

                  return _buildServiceCategoryGroup(context, category, categoryServices);
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final bookingState = ref.watch(bookingFlowProvider);
          if (bookingState.selectedServices.isEmpty) return const SizedBox.shrink();

          return Container(
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${bookingState.selectedServices.length} Services Selected', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Est. ₹${bookingState.totalPrice.toStringAsFixed(0)} • ${bookingState.totalDuration} mins', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/book');
                    },
                    child: const Text('Continue to Book'),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildServiceCategoryGroup(BuildContext context, ServiceCategory category, List<ServiceModel> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            category.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        ...services.map((service) => _buildServiceCard(context, service)),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceModel service) {
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
                  Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(service.shortDescription, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('₹${service.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.deepPlum)),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${service.durationMinutes} mins', style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                    _showServiceDetails(context, service);
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

  void _showServiceDetails(BuildContext context, ServiceModel service) {
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
                if (service.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(service.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
                  )
                else
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
                Text(service.name, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('₹${service.price.toStringAsFixed(0)} • ${service.durationMinutes} mins', style: const TextStyle(fontSize: 16, color: AppTheme.deepPlum, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                const Text('Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(service.detailedDescription),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: Consumer(
                    builder: (context, ref, child) {
                      return ElevatedButton(
                        onPressed: () {
                          ref.read(bookingFlowProvider.notifier).addService(service);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${service.name} added to booking'),
                              backgroundColor: AppTheme.deepPlum,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('Add to Booking'),
                      );
                    }
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
