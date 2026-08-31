import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../models/service_category.dart';
import '../../models/service_model.dart';
import '../../models/portfolio_item.dart';

class FirebaseSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedDatabase() async {
    print('Seeder: Starting database seed (using individual writes)...');
    const uuid = Uuid();

    // 1. Seed Categories
    final categories = [
      ServiceCategory(id: uuid.v4(), name: 'Bridal', imageUrl: 'https://images.unsplash.com/photo-1595959183082-7b570b7e08e2?q=80&w=1000&auto=format&fit=crop', sortOrder: 0),
      ServiceCategory(id: uuid.v4(), name: 'Facials', imageUrl: 'https://images.unsplash.com/photo-1570172619644-defd00c4391e?q=80&w=1000&auto=format&fit=crop', sortOrder: 1),
      ServiceCategory(id: uuid.v4(), name: 'Hair Care', imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop', sortOrder: 2),
      ServiceCategory(id: uuid.v4(), name: 'Nails', imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=1000&auto=format&fit=crop', sortOrder: 3),
      ServiceCategory(id: uuid.v4(), name: 'Waxing', imageUrl: 'https://images.unsplash.com/photo-1596755389378-c31d21fd1273?q=80&w=1000&auto=format&fit=crop', sortOrder: 4),
    ];

    print('Seeder: Writing categories...');
    for (var cat in categories) {
      await _firestore.collection('categories').doc(cat.id).set(cat.toMap());
    }

    // 2. Seed Services
    final services = [
      ServiceModel(
        id: uuid.v4(),
        name: 'Signature Bridal Glow',
        categoryId: categories[0].id,
        price: 25000.0,
        durationMinutes: 180,
        shortDescription: 'Complete HD makeup and luxury hair styling for your big day.',
        detailedDescription: 'Includes pre-wedding consultation, skin prep with luxury oils, HD waterproof makeup, premium false lashes, elaborate hair styling, and dupatta draping.',
        suitabilityTag: 'Bridal',
        imageUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=1000&auto=format&fit=crop',
        isPopular: true,
        isVisible: true,
      ),
      ServiceModel(
        id: uuid.v4(),
        name: 'Party Ready Makeup',
        categoryId: categories[0].id,
        price: 4500.0,
        durationMinutes: 60,
        shortDescription: 'Flawless makeup and simple curls for evening parties.',
        detailedDescription: 'Perfect for bridesmaids or party guests. Includes skin prep, long-lasting makeup, and simple blow-dry or soft curls.',
        suitabilityTag: 'Party',
        imageUrl: 'https://images.unsplash.com/photo-1512496015851-a1dc8a47de1b?q=80&w=1000&auto=format&fit=crop',
        isPopular: true,
        isVisible: true,
      ),
      ServiceModel(
        id: uuid.v4(),
        name: '24K Gold Facial',
        categoryId: categories[1].id,
        price: 3000.0,
        durationMinutes: 90,
        shortDescription: 'Anti-aging luxury facial with real 24k gold dust.',
        detailedDescription: 'A premium 8-step facial that brightens and firms the skin. Includes deep cleanse, exfoliation, gold serum massage, and a hydrating 24k gold mask.',
        suitabilityTag: 'Anti-aging',
        imageUrl: 'https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?q=80&w=1000&auto=format&fit=crop',
        isPopular: true,
        isVisible: true,
      ),
      ServiceModel(
        id: uuid.v4(),
        name: 'Keratin Hair Spa',
        categoryId: categories[2].id,
        price: 2000.0,
        durationMinutes: 60,
        shortDescription: 'Deep conditioning treatment for frizzy, dry hair.',
        detailedDescription: 'Restores protein to your hair. Includes a relaxing 15-minute head massage, steam therapy, and protein mask application.',
        suitabilityTag: 'Dry Hair',
        imageUrl: 'https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=1000&auto=format&fit=crop',
        isPopular: false,
        isVisible: true,
      ),
      ServiceModel(
        id: uuid.v4(),
        name: 'Luxury Gel Manicure',
        categoryId: categories[3].id,
        price: 1500.0,
        durationMinutes: 45,
        shortDescription: 'Chip-resistant gel polish with cuticle care.',
        detailedDescription: 'Full manicure including nail shaping, cuticle oil treatment, hand massage, and long-lasting gel polish in a color of your choice.',
        suitabilityTag: 'Nails',
        imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=1000&auto=format&fit=crop',
        isPopular: false,
        isVisible: true,
      ),
    ];

    print('Seeder: Writing services...');
    for (var service in services) {
      await _firestore.collection('services').doc(service.id).set(service.toMap());
    }

    // 3. Seed Portfolio
    final portfolioItems = [
      PortfolioItem(
        id: uuid.v4(),
        title: 'Morning Wedding Elegance',
        imageUrl: 'https://images.unsplash.com/photo-1595959183082-7b570b7e08e2?q=80&w=1000&auto=format&fit=crop',
        tags: ['Bridal', 'Makeup'],
        description: 'A soft, peachy daytime bridal look. Focus was on creating a glowing, skin-like finish.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PortfolioItem(
        id: uuid.v4(),
        title: 'Evening Glam Cocktail',
        imageUrl: 'https://images.unsplash.com/photo-1512496015851-a1dc8a47de1b?q=80&w=1000&auto=format&fit=crop',
        beforeImageUrl: 'https://images.unsplash.com/photo-1580618672591-eb180b1a973f?q=80&w=1000&auto=format&fit=crop',
        tags: ['Party', 'Hair'],
        description: 'Full glam transformation with smokey eyes and voluminous Hollywood waves.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      PortfolioItem(
        id: uuid.v4(),
        title: 'Classic Red Lip',
        imageUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=1000&auto=format&fit=crop',
        tags: ['Makeup'],
        description: 'A timeless classic look featuring winged eyeliner and a bold matte red lip.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      PortfolioItem(
        id: uuid.v4(),
        title: 'Balayage Transformation',
        imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop',
        beforeImageUrl: 'https://images.unsplash.com/photo-1522337660859-02fbefca4702?q=80&w=1000&auto=format&fit=crop',
        tags: ['Hair'],
        description: 'Corrected brassy tones and added cool, dimensional ash blonde balayage.',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];

    print('Seeder: Writing portfolio...');
    for (var item in portfolioItems) {
      await _firestore.collection('portfolio').doc(item.id).set(item.toMap());
    }

    print('Seeder: Database seed completed successfully.');
  }
}
