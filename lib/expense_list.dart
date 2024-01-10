import 'package:expense_tracker/expense_item.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expenses, required this.removeFn});

  final List<Expense> expenses;
  final void Function(Expense expense) removeFn;

  @override
  Widget build(BuildContext context) {
    // ListView.builder => build an scrollable list based on length of the list
    // this widget is good for performance because it use lazy load
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => Dismissible(
              key: ValueKey(expenses[index]),
              onDismissed: (direction) {
                removeFn(expenses[index]);
              },
              child: ExpenseItem(expenses[index]),
            ));
  }
}
