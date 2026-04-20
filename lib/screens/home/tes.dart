import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toksort_frontend/models/groupproduct_model.dart';
import 'package:toksort_frontend/services/api_services.dart';
import 'package:toksort_frontend/models/product_model.dart';
import 'package:toksort_frontend/state/history_store.dart';

class HomeView extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeView({super.key, required this.onToggleTheme});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = true;
  // List data = [];
  List<Product> data = [];
  List<GroupedProduct> groupedData = [];
  List<String> selectedJenis = [];
  List<String> selectedBahan = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final responseData = await ApiService.getLatestProducts();

      print("🔥 RESPONSE DATA: $responseData");
      print("🔥 LENGTH: ${responseData.length}");

      final grouped = groupProducts(responseData);

      setState(() {
        data = responseData;
        groupedData = grouped; // 🔥 INI YANG KURANG
        isLoading = false;
      });
    } catch (e) {
      print("❌ ERROR FETCH: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  // 🔥 GROUPING LOGIC
  List<GroupedProduct> groupProducts(List<Product> products) {
    final Map<String, List<Product>> map = {};

    for (var p in products) {
      final key = (p.productCategory).trim();

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

  // Filters
  Future<void> openFilter() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterPopup(),
    );

    if (result != null) {
      applyFilter(result);
    }
  }

  void applyFilter(Map filter) {
    selectedJenis = List<String>.from(filter["jenis"]);
    selectedBahan = List<String>.from(filter["bahan"]);

    final filtered =
        data.where((product) {
          final matchJenis =
              selectedJenis.isEmpty ||
              selectedJenis.contains(product.productCategory);

          final matchBahan =
              selectedBahan.isEmpty ||
              selectedBahan.any((b) => product.variation.contains(b));

          return matchJenis && matchBahan;
        }).toList();

    setState(() {
      groupedData = groupProducts(filtered);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(20), child: _buildBody()),
      ),

    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return _emptyView();
    }

    return _contentView();
  }

  /// 🔥 EMPTY STATE
  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 60),
          const SizedBox(height: 10),
          Text(
            "Belum ada produk",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          Text(
            "Upload CSV untuk mulai",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  /// 🔥 CONTENT STATE (GROUPED)
  Widget _contentView() {
    return ListView.builder(
      itemCount: groupedData.length,
      itemBuilder: (context, index) {
        final item = groupedData[index];
        print("🔥 GROUPED: ${groupedData.length}");
        return _ExpandableCard(
          data: item,
          onDone: (doneItem) {
            setState(() {
              groupedData.remove(doneItem);
            });
          },
        );
      },
    );
  }
}

class _ExpandableCard extends StatefulWidget {
  final GroupedProduct data;
  final Function(GroupedProduct) onDone;

  const _ExpandableCard({required this.data, required this.onDone});

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 HEADER
          GestureDetector(
            onTap: () {
              setState(() => isExpanded = !isExpanded);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Jenis : ${data.category} • Total Jumlah ${data.total}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),

          /// 🔥 EXPAND
          if (isExpanded) ...[
            const SizedBox(height: 12),

            const Text("Detail Pesanan :"),

            const SizedBox(height: 8),

            ...data.items.map((item) {
              return _detailItem(item);
            }),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final historyStore = context.read<HistoryStore>();

                  historyStore.addToHistory(data);

                  // 🔥 hapus dari home
                  widget.onDone(data);
                },
                child: const Text("Selesai"),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailItem(Product item) {
    Color dotColor =
        item.variation.toLowerCase().contains("merah")
            ? Colors.red
            : Colors.green;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "${item.variation} : ${item.quantity} pcs (${item.shippingStatus})",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

// Filters Pop up
class FilterPopup extends StatefulWidget {
  const FilterPopup({super.key});

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  List<String> selectedJenis = [];
  List<String> selectedBahan = [];

  final jenisList = ["Kolam", "Penutup Truck", "Tenda Acara", "Karung Kurir"];
  final bahanList = [
    "Plastik A3",
    "Plastik A5",
    "Plastik A8",
    "Plastik A12",
    "Plastik A20",
    "Orchid Semi Karet",
  ];

  void toggleItem(List<String> list, String value) {
    setState(() {
      if (list.contains(value)) {
        list.remove(value);
      } else {
        list.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedJenis.clear();
                    selectedBahan.clear();
                  });
                },
                child: const Text("Reset", style: TextStyle(color: Colors.red)),
              ),
              const Text(
                "Filters",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 40), // balance layout
            ],
          ),

          const SizedBox(height: 20),

          /// JENIS
          const Text("Jenis", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                jenisList.map((item) {
                  final isSelected = selectedJenis.contains(item);

                  return ChoiceChip(
                    label: Text(item),
                    selected: isSelected,
                    onSelected: (_) => toggleItem(selectedJenis, item),
                  );
                }).toList(),
          ),

          const SizedBox(height: 20),

          /// BAHAN
          const Text(
            "Jenis Bahan",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                bahanList.map((item) {
                  final isSelected = selectedBahan.contains(item);

                  return ChoiceChip(
                    label: Text(item),
                    selected: isSelected,
                    onSelected: (_) => toggleItem(selectedBahan, item),
                  );
                }).toList(),
          ),

          const SizedBox(height: 25),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                print("Jenis: $selectedJenis");
                print("Bahan: $selectedBahan");

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Simpan"),
            ),
          ),
        ],
      ),
    );
  }
}
