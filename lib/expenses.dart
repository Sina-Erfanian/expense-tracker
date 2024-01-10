import 'package:expense_tracker/expense_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        amount: 10.99,
        date: DateTime.now(),
        title: "Flutter course",
        category: Category.work),
    Expense(
        amount: 19.29,
        date: DateTime.now(),
        title: "Cinema",
        category: Category.leisure),
  ];
  void addExpenses(amount, date, title, category) {
    setState(() {
      _registeredExpenses.add(Expense(
          amount: amount, date: date, title: title, category: category));
    });
  }

  void removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text("Expense Deleted."),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  void showModalOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(addExpenses));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text("No expenses found.Start adding some"),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent =
          ExpenseList(expenses: _registeredExpenses, removeFn: removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(onPressed: showModalOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
