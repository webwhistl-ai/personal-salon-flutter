import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../theme/theme.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../models/portfolio_item.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAsync = ref.watch(portfolioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transformations'),
        backgroundColor: AppTheme.ivory,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Bridal', false),
                _buildFilterChip('Hair Color', false),
                _buildFilterChip('Makeup', false),
                _buildFilterChip('Nails', false),
              ],
            ),
          ),
        ),
      ),
      body: portfolioAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading portfolio: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No transformations to show yet.'));
          }
          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final isLarge = index % 3 == 0;
              return _buildPortfolioItem(context, isLarge, items[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {},
        selectedColor: AppTheme.roseGold.withAlpha(50),
        checkmarkColor: AppTheme.deepPlum,
      ),
    );
  }

  Widget _buildPortfolioItem(BuildContext context, bool isLarge, PortfolioItem item) {
    return InkWell(
      onTap: () {
        // Show details/slider
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: isLarge ? 250 : 150,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                  if (item.beforeImageUrl != null && item.beforeImageUrl!.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Before / After', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(item.description, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
