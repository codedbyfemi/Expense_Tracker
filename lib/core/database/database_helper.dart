import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../models/expense.dart';
import '../../models/category.dart';
import 'database_tables.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  // Singleton pattern - only one instance
  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  // Get database instance
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create tables when database is first created
  Future<void> _onCreate(Database db, int version) async {
    print('DatabaseHelper: _onCreate called');

    await db.execute(DatabaseTables.createExpensesTable);
    print('DatabaseHelper: Expenses table created');

    await db.execute(DatabaseTables.createCategoriesTable);
    print('DatabaseHelper: Categories table created');

    // Insert default categories - PASS the db parameter directly
    await _insertDefaultCategoriesWithDb(db);
    print('DatabaseHelper: _onCreate completed');
  }

// CREATE - Insert a new expense
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

// READ - Get all expenses
  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

// READ - Get expenses by date range
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

// UPDATE - Modify an existing expense
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

// DELETE - Remove an expense
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // === CATEGORY METHODS ===

// CREATE - Insert a new category
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

// READ - Get all categories
  Future<List<Category>> getCategories() async {
    print('DatabaseHelper: getCategories() called');
    try {
      final db = await database;
      print('DatabaseHelper: Database obtained');

      final List<Map<String, dynamic>> maps = await db.query('categories');
      print('DatabaseHelper: Query completed, found ${maps.length} categories');

      final categories = List.generate(maps.length, (i) {
        return Category.fromMap(maps[i]);
      });

      print('DatabaseHelper: Categories converted to objects');
      return categories;
    } catch (e) {
      print('DatabaseHelper: Error in getCategories: $e');
      rethrow;
    }
  }

// READ - Get category by ID
  Future<Category?> getCategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    }
    return null;
  }

// UPDATE - Modify an existing category
  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

// DELETE - Remove a category
  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // PRIVATE method that accepts database as parameter (no infinite loop)
  Future<void> _insertDefaultCategoriesWithDb(Database db) async {
    print('DatabaseHelper: _insertDefaultCategoriesWithDb() called');

    // Check if categories already exist
    final List<Map<String, dynamic>> existingCategories = await db.query('categories');
    print('DatabaseHelper: Found ${existingCategories.length} existing categories');

    if (existingCategories.isEmpty) {
      print('DatabaseHelper: Inserting default categories...');

      final defaultCategories = [
        Category(name: 'Food', icon: '🍕', color: '#FF5722'),
        Category(name: 'Transport', icon: '🚗', color: '#2196F3'),
        Category(name: 'Shopping', icon: '🛍️', color: '#9C27B0'),
        Category(name: 'Entertainment', icon: '🎬', color: '#FF9800'),
        Category(name: 'Health', icon: '🏥', color: '#4CAF50'),
        Category(name: 'Bills', icon: '📄', color: '#795548'),
        Category(name: 'Other', icon: '📝', color: '#607D8B'),
      ];

      for (Category category in defaultCategories) {
        final id = await db.insert('categories', category.toMap());
        print('DatabaseHelper: Inserted category ${category.name} with id $id');
      }
      print('DatabaseHelper: All default categories inserted');
    } else {
      print('DatabaseHelper: Categories already exist, skipping insertion');
    }
  }

// Keep the original insertDefaultCategories for external use
  Future<void> insertDefaultCategories() async {
    final db = await database;
    await _insertDefaultCategoriesWithDb(db);
  }

}