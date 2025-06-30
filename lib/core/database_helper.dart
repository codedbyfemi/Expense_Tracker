import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/expense.dart';
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
    await db.execute(DatabaseTables.createExpensesTable);
    await db.execute(DatabaseTables.createCategoriesTable);
  }

// TODO: Add CRUD methods for expenses
// We'll add these methods next
}