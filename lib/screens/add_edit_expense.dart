// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/expense_model.dart';
import '../data/expense_provider.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddEditExpenseScreen({super.key, this.expense});

  @override
  _AddEditExpenseScreenState createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _dateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(widget.expense!.dateTime);
      _descriptionController.text = widget.expense!.description;
      _amountController.text = widget.expense!.amount.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _dateTimeController,
              decoration: const InputDecoration(labelText: 'Date and Time', border: OutlineInputBorder()),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDateTime = await showDatePicker(
                  context: context,
                  initialDate: widget.expense?.dateTime ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDateTime != null) {
                  TimeOfDay? pickedTimeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(widget.expense?.dateTime ?? DateTime.now()),
                  );
                  if (pickedTimeOfDay != null) {
                    final pickedDateTimeWithTime = DateTime(
                      pickedDateTime.year,
                      pickedDateTime.month,
                      pickedDateTime.day,
                      pickedTimeOfDay.hour,
                      pickedTimeOfDay.minute,
                    );
                    _dateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(pickedDateTimeWithTime);
                  }
                }
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              maxLines: null,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (widget.expense == null) {
                  _addExpense(context);
                } else {
                  _editExpense(context);
                }
              },
              child: Text(
                widget.expense == null ? 'Save Expense' : 'Update Expense',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addExpense(BuildContext context) {
    final String dateTimeString = _dateTimeController.text;
    final String description = _descriptionController.text;
    final String amountString = _amountController.text;

    if (dateTimeString.isEmpty || description.isEmpty || amountString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all fields.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    final DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm').parse(dateTimeString);
    final double amount = double.parse(amountString);

    final Expense expense = Expense(
      id: DateTime.now().toString(),
      dateTime: dateTime,
      description: description,
      amount: amount,
    );

    Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);

    Navigator.pop(context); // Go back to previous screen after saving
  }

  void _editExpense(BuildContext context) {
    final String dateTimeString = _dateTimeController.text;
    final String description = _descriptionController.text;
    final String amountString = _amountController.text;

    if (dateTimeString.isEmpty || description.isEmpty || amountString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm').parse(dateTimeString);
    final double amount = double.parse(amountString);

    final updatedExpense = widget.expense!.copyWith(dateTime: dateTime, description: description, amount: amount);

    Provider.of<ExpenseProvider>(context, listen: false).updateExpense(widget.expense!.id, updatedExpense);

    Navigator.pop(context); // Go back to previous screen after updating
  }
}
