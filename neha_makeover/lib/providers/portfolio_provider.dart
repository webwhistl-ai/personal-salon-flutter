import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/portfolio_repository.dart';
import '../models/portfolio_item.dart';

final portfolioRepositoryProvider = Provider<PortfolioRepository>((ref) {
  return PortfolioRepository();
});

final portfolioProvider = StreamProvider<List<PortfolioItem>>((ref) {
  return ref.watch(portfolioRepositoryProvider).getPortfolioItems();
});
