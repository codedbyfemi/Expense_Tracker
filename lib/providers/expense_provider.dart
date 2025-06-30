import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../core/database/database_helper.dart';

class ExpenseProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Private list of expenses
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;

  // Public getters
  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get total balance
  double get totalBalance {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Get expenses for current month
  List<Expense> get currentMonthExpenses {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return _expenses.where((expense) {
      return expense.date.isAfter(startOfMonth) &&
          expense.date.isBefore(endOfMonth.add(Duration(days: 1)));
    }).toList();
  }

// TODO: Add CRUD methods
// Load all expenses from database
  Future<void> loadExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await _databaseHelper.getExpenses();
    } catch (e) {
      _error = 'Failed to load expenses: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// Add a new expense
  Future<void> addExpense(Expense expense) async {
    try {
      final id = await _databaseHelper.insertExpense(expense);
      final newExpense = expense.copyWith(id: id);
      _expenses.add(newExpense);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add expense: $e';
      notifyListeners();
    }
  }

// Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    try {
      await _databaseHelper.updateExpense(expense);
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update expense: $e';
      notifyListeners();
    }
  }

// Delete an expense
  Future<void> deleteExpense(int id) async {
    try {
      await _databaseHelper.deleteExpense(id);
      _expenses.removeWhere((expense) => expense.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete expense: $e';
      notifyListeners();
    }
  }

// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }}