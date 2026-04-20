import 'package:flutter/material.dart';
import 'package:toksort_frontend/models/product_model.dart';
import 'package:toksort_frontend/models/groupproduct_model.dart';
import 'package:toksort_frontend/services/api_services.dart';

class HomeController extends ChangeNotifier {
  bool isLoading = true;
  bool isFiltered = false;

  List<Product> _allData = []; // 🔥 data asli (JANGAN PERNAH DIUBAH)
  List<GroupedProduct> groupedData = []; // 🔥 data tampil

  List<String> selectedJenis = [];
  List<String> selectedBahan = [];

  bool get isFilterActive =>
      selectedJenis.isNotEmpty || selectedBahan.isNotEmpty;

  Future<void> fetchData() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await ApiService.getLatestProducts();

      _allData = response;
      groupedData = _groupProducts(_allData);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  void setData(List<Product> products) {
    _allData = products; // simpan asli
    groupedData = _groupProducts(products); // tampilkan
    notifyListeners();
  }

  void applyFilter(List<String> jenis, List<String> bahan) {
    isFiltered = true;

    final filtered =
        _allData.where((p) {
          final matchJenis = jenis.isEmpty || jenis.contains(p.productCategory);

          final matchBahan =
              bahan.isEmpty ||
              bahan.any(
                (b) => p.variation.toLowerCase().contains(b.toLowerCase()),
              );

          return matchJenis && matchBahan;
        }).toList();

    groupedData = _groupProducts(filtered);
    notifyListeners();
  }

  void resetFilter() {
    isFiltered = false;
    groupedData = _groupProducts(_allData); // 🔥 balik ke data asli
    notifyListeners();
  }

  void removeGroup(GroupedProduct item) {
    groupedData.remove(item);
    notifyListeners();
  }

  List<GroupedProduct> _groupProducts(List<Product> products) {
    final Map<String, List<Product>> map = {};

    for (var p in products) {
      final key = (p.productCategory ?? "").trim();

      map.putIfAbsent(key, () => []);
      map[key]!.add(p);
    }

    final List<GroupedProduct> result = [];

    map.forEach((category, items) {
      final total = items.fold(0, (sum, item) => sum + item.quantity);

      result.add(
        GroupedProduct(category: category, total: total, items: items),
      );
    });

    return result;
  }
}
