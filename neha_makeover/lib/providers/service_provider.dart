import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/service_repository.dart';
import '../models/service_model.dart';
import '../models/service_category.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository();
});

final categoriesProvider = StreamProvider<List<ServiceCategory>>((ref) {
  return ref.watch(serviceRepositoryProvider).getCategories();
});

final servicesProvider = StreamProvider<List<ServiceModel>>((ref) {
  return ref.watch(serviceRepositoryProvider).getServices();
});
