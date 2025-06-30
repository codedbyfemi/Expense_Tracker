import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// We'll add these imports as we create the files
// import 'providers/expense_provider.dart';
// import 'screens/home/home_screen.dart';

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Expense Tracker - Coming Soon!'),
        ),
      ),
    );
  }
}