import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/service_provider.dart';

class AdminServicesScreen extends ConsumerWidget {
  const AdminServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Services'),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Service'),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: servicesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error loading services: $e')),
          data: (services) {
            if (services.isEmpty) {
              return const Center(child: Text('No services found.'));
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (service.imageUrl.isNotEmpty)
                              Image.network(service.imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)))
                            else
                              Container(color: Colors.grey.shade200, child: const Center(child: Icon(Icons.spa, size: 48, color: Colors.purple))),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                decoration: BoxDecoration(color: Colors.white.withAlpha(200), borderRadius: BorderRadius.circular(12)),
                                child: Switch(
                                  value: service.isVisible,
                                  onChanged: (val) {
                                    // Real implementation would update Firestore
                                  },
                                  activeThumbColor: Colors.purple,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text('₹${service.price.toStringAsFixed(0)} • ${service.durationMinutes} mins', style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                TextButton.icon(onPressed: () {}, icon: const Icon(Icons.edit, size: 16), label: const Text('Edit')),
                                const Spacer(),
                                IconButton(onPressed: () {}, icon: const Icon(Icons.delete, size: 20, color: Colors.red)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
