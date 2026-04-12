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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.spa, size: 32, color: Colors.purple),
                            Switch(value: service.isVisible, onChanged: (val) {
                                // Real implementation would update Firestore
                            }),
                          ],
                        ),
                        const Spacer(),
                        Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Text('₹${service.price.toStringAsFixed(0)} • ${service.durationMinutes} mins', style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.edit, size: 16), label: const Text('Edit')),
                            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.delete, size: 16, color: Colors.red), label: const Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        )
                      ],
                    ),
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
