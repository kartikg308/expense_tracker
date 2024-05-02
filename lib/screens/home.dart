import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'add_edit_expense.dart';
import '../model/expense_model.dart';
import '../controller/expense_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final List<Expense> expenses = expenseProvider.expenses;

    // Calculate total expenses for daily, weekly, and monthly periods
    final double dailyExpenses = _calculatePeriodExpenses(DateTime.now(), expenses);
    final double weeklyExpenses = _calculateWeeklyExpenses(DateTime.now(), expenses);
    final double monthlyExpenses = _calculateMonthlyExpenses(DateTime.now(), expenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Expense Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Daily Expenses',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          dailyExpenses.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Weekly Expenses',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          weeklyExpenses.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Monthly Expenses',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          monthlyExpenses.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Expenses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return _buildExpenseTile(context, expense);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddEditExpenseScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildExpenseTile(BuildContext context, Expense expense) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEditExpenseScreen(expense: expense)));
      },
      title: Text(
        expense.description,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
          Text('Date: ${DateFormat('yyyy-MM-dd').format(expense.dateTime)}'),
          Text('Time: ${DateFormat('HH:mm').format(expense.dateTime)}'),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          _deleteExpense(context, expense.id);
        },
      ),
    );
  }

  void _deleteExpense(BuildContext context, String id) {
    Provider.of<ExpenseProvider>(context, listen: false).deleteExpense(id);
  }

  double _calculatePeriodExpenses(DateTime date, List<Expense> expenses) {
    return expenses.where((expense) => expense.dateTime.year == date.year && expense.dateTime.month == date.month && expense.dateTime.day == date.day).fold(0.0, (prev, curr) => prev + curr.amount);
  }

  double _calculateWeeklyExpenses(DateTime date, List<Expense> expenses) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    return expenses.where((expense) => expense.dateTime.isAfter(startOfWeek.subtract(const Duration(days: 1))) && expense.dateTime.isBefore(endOfWeek.add(const Duration(days: 1)))).fold(0.0, (prev, curr) => prev + curr.amount);
  }

  double _calculateMonthlyExpenses(DateTime date, List<Expense> expenses) {
    return expenses.where((expense) => expense.dateTime.year == date.year && expense.dateTime.month == date.month).fold(0.0, (prev, curr) => prev + curr.amount);
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Sort by Date (Ascending)'),
              onTap: () {
                Provider.of<ExpenseProvider>(context, listen: false).sortByDate(ascending: true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Sort by Date (Descending)'),
              onTap: () {
                Provider.of<ExpenseProvider>(context, listen: false).sortByDate(ascending: false);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
