import 'package:toksort_frontend/models/product_model.dart';

class GroupedProduct {
  final String category;
  final int total;
  final List<Product> items;

  GroupedProduct({
    required this.category,
    required this.total,
    required this.items,
  });
}