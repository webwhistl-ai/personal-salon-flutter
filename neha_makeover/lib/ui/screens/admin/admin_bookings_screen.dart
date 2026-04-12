import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/booking_flow_provider.dart';
import '../../../models/booking_model.dart';

final allBookingsProvider = StreamProvider<List<BookingModel>>((ref) {
  return ref.watch(bookingRepositoryProvider).getAllBookings();
});

class AdminBookingsScreen extends ConsumerWidget {
  const AdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(allBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bookings'),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('New Booking'),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by customer name or ID...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownMenu<String>(
                  initialSelection: 'All',
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'All', label: 'All Statuses'),
                    DropdownMenuEntry(value: 'Pending', label: 'Pending'),
                    DropdownMenuEntry(value: 'Confirmed', label: 'Confirmed'),
                    DropdownMenuEntry(value: 'Completed', label: 'Completed'),
                  ],
                  onSelected: (val) {},
                ),
                const SizedBox(width: 16),
                IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.calendar_month)),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: bookingsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error loading bookings: $e')),
                  data: (bookings) {
                    if (bookings.isEmpty) {
                      return const Center(child: Text('No bookings found.'));
                    }
                    return ListView.separated(
                      itemCount: bookings.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        final status = booking.status[0].toUpperCase() + booking.status.substring(1);
                        final color = status == 'Pending' ? Colors.orange : (status == 'Confirmed' ? Colors.green : Colors.grey);

                        return ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text('Customer ${booking.customerId.substring(0, 5)}...', style: const TextStyle(fontWeight: FontWeight.bold)), // In a real app we join users collection
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${booking.serviceIds.length} Services • ₹${booking.totalPrice.toStringAsFixed(0)}'),
                              Text(DateFormat('MMM d, yyyy • hh:mm a').format(booking.dateTime), style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(16)),
                                child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                              const SizedBox(width: 16),
                              IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
