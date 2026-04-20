import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toksort_frontend/state/history_store.dart';
import 'package:toksort_frontend/models/groupproduct_model.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final historyItems = context.watch<HistoryStore>().history;

    if (historyItems.isEmpty) {
      return Center(
        child: Text(
          "Belum ada history",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: historyItems.length,
      itemBuilder: (context, index) {
        final item = historyItems[index];

        return _historyCard(context, item);
      },
    );
  }

  // 🔥 UI CARD (punya lo, gak diubah)
  Widget _historyCard(BuildContext context, GroupedProduct item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Jenis : ${item.category} • Total Jumlah ${item.total}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Selesai",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}