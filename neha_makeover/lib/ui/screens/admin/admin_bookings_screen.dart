import 'package:flutter/material.dart';

class AdminBookingsScreen extends StatelessWidget {
  const AdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: ListView.separated(
                  itemCount: 10,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final status = index == 0 ? 'Pending' : 'Confirmed';
                    final color = index == 0 ? Colors.orange : Colors.green;
                    return ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text('Customer Name ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bridal Makeup • ₹15,000'),
                          Text('Oct 17, 2023 • 11:00 AM', style: TextStyle(color: Colors.grey)),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
