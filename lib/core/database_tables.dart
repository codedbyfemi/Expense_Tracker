class DatabaseTables {
  // SQL command to create the expenses table
  static const String createExpensesTable = '''
    CREATE TABLE expenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      categoryId INTEGER NOT NULL,
      date INTEGER NOT NULL,
      description TEXT
    )
  ''';

  // We'll add more tables later (like categories)
  static const String createCategoriesTable = '''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      icon TEXT NOT NULL,
      color TEXT NOT NULL
    )
  ''';
}