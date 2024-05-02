import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'expense_model.dart';

class ExpenseProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  List<Expense> _expenses = [];

  ExpenseProvider() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? expensesString = _prefs.getStringList('expenses');
    if (expensesString != null) {
      _expenses = expensesString.map((e) => Expense.fromJson(jsonDecode(e))).toList();
    }
    notifyListeners();
  }

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpenses();
    notifyListeners();
  }

  Future<void> _saveExpenses() async {
    List<String> encodedExpenses = _expenses.map((expense) => jsonEncode(expense.toJson())).toList();
    await _prefs.setStringList('expenses', encodedExpenses);
  }

  void sortByDate({required bool ascending}) {
    _expenses.sort((a, b) => ascending ? a.dateTime.compareTo(b.dateTime) : b.dateTime.compareTo(a.dateTime));
    notifyListeners();
  }

  void sortByTime({required bool ascending}) {
    _expenses.sort((a, b) => ascending ? a.dateTime.compareTo(b.dateTime) : b.dateTime.compareTo(a.dateTime));
    notifyListeners();
  }

  void updateExpense(String id, Expense updatedExpense) {
    final index = _expenses.indexWhere((expense) => expense.id == id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      _saveExpenses();
      notifyListeners();
    }
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpenses();
    notifyListeners();
  }
}
