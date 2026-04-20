import 'package:flutter/material.dart';
import '../models/groupproduct_model.dart';

class HistoryStore extends ChangeNotifier {
  final List<GroupedProduct> _history = [];

  List<GroupedProduct> get history => _history;

  void addToHistory(GroupedProduct data) {
    _history.add(data);
    notifyListeners();
  }
}