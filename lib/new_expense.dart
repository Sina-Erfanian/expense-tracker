import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense(
    this.addExpenses, {
    super.key,
  });
  final void Function(
          double amount, DateTime date, String title, Category category)
      addExpenses;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void submitDataForm() {
    final amount = double.tryParse(_amountController.text);
    final amountIsValid = amount == null || amount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Invalid input"),
            content: const Text(
                "Please make sure a valid title, amount, date and category was entered."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text("Okay"))
            ],
          );
        },
      );
      return;
    }

    widget.addExpenses(
        amount, _selectedDate!, _titleController.text, _selectedCategory);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(children: [
        TextField(
          controller: _titleController,
          maxLength: 50,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(label: Text("Title")),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    label: Text("amount"), prefixText: "\$ "),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Row(
                children: [
                  Text(_selectedDate == null
                      ? "No date selected"
                      : formatter.format(_selectedDate!)),
                  IconButton(
                    onPressed: _datePicker,
                    icon: const Icon(Icons.calendar_month),
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.name.toUpperCase(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                }),
            const Spacer(),
            TextButton(
                onPressed: () {
                  // REMOVE the modal
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            ElevatedButton(
                onPressed: submitDataForm, child: const Text("Save Expense"))
          ],
        )
      ]),
    );
  }
}
