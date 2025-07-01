import 'package:flutter/foundation.dart';
import '../models/category.dart' as models;
import '../core/database/database_helper.dart';

class CategoryProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<models.Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  // Public getters
  List<models.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all categories from database
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _databaseHelper.getCategories();
    } catch (e) {
      _error = 'Failed to load categories: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get category by ID
  models.Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new category
  Future<void> addCategory(models.Category category) async {
    try {
      final id = await _databaseHelper.insertCategory(category);
      final newCategory = category.copyWith(id: id);
      _categories.add(newCategory);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add category: $e';
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Add this method to CategoryProvider
  Future<void> debugCategories() async {
    print('CategoryProvider: Starting to load categories...');
    try {
      final categories = await _databaseHelper.getCategories();
      print('CategoryProvider: Found ${categories.length} categories');
      for (var cat in categories) {
        print('Category: ${cat.name} - ${cat.icon}');
      }
    } catch (e) {
      print('CategoryProvider: Error loading categories: $e');
    }
  }
}