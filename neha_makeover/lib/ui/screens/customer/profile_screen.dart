import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    String initials = 'U';
    String displayName = 'Guest User';
    String email = '';

    if (user != null) {
      displayName = user.displayName ?? 'User';
      email = user.email ?? 'Guest Access';
      if (displayName.isNotEmpty) {
        initials = displayName.substring(0, 1).toUpperCase();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppTheme.ivory,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppTheme.roseGold,
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null ? Text(initials, style: const TextStyle(color: Colors.white, fontSize: 24)) : null,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName, style: Theme.of(context).textTheme.headlineMedium),
                  Text(email, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Upcoming Bookings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          _buildBookingCard(),
          const SizedBox(height: 32),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Past Bookings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('Saved Looks'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go('/login');
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.champagne,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Confirmed', style: TextStyle(color: AppTheme.deepPlum, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const Text('Oct 17 • 11:00 AM', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Bridal Makeup Package', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Text('Est. 3 Hours', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Reschedule'))),
                const SizedBox(width: 16),
                Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('Get Directions'))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
