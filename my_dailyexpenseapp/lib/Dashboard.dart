import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_dailyexpenseapp/Account.dart';
import 'package:my_dailyexpenseapp/Details.dart';
import 'package:my_dailyexpenseapp/Help.dart';

class DashboardScreen extends StatefulWidget {
  double monthlyBudget;

  DashboardScreen({super.key, required this.monthlyBudget});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _expenses = [];
  double _totalExpenses = 0;

  double get _remainingBudget => widget.monthlyBudget - _totalExpenses;

  void _addExpense() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedCategory = 'Food';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Expense Title',
                ),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹ ',
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: ['Food', 'Grocery', 'Shopping', 'Dining Out', 'Other']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  double amount = double.parse(amountController.text);

                  setState(() {
                    _expenses.add({
                      'title': titleController.text,
                      'amount': amount,
                      'date': selectedDate,
                      'category': selectedCategory,
                    });
                    _totalExpenses += amount;
                  });

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteExpense(int index) {
    setState(() {
      _totalExpenses -= _expenses[index]['amount'];
      _expenses.removeAt(index);
    });
  }

  void _editBudget() async {
    final updatedBudget = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBudgetScreen(budget: widget.monthlyBudget),
      ),
    );

    if (updatedBudget != null && updatedBudget != widget.monthlyBudget) {
      setState(() {
        widget.monthlyBudget = updatedBudget;
      });
    }
  }

  void _onMenuItemSelected(String value) {
  switch (value) {
    case 'account':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountScreen()),
      );
      break;
    case 'help':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HelpPage()),
      );
      break;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker Dashboard'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuItemSelected,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'account',
                child: Row(
                  children: [
                    Icon(Icons.account_circle),
                    SizedBox(width: 8),
                    Text('Account'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline),
                    SizedBox(width: 8),
                    Text('Help'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Monthly Budget',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                            onPressed: _editBudget,
                          ),
                        ],
                      ),
                      Text(
                        '₹${widget.monthlyBudget.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Remaining Budget',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${_remainingBudget.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          color: _remainingBudget >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _expenses.isEmpty
                ? const Center(
                    child: Text(
                      'No expenses added yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) {
                      final expense = _expenses[index];
                      return Dismissible(
                        key: Key(expense['title'] + expense['date'].toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteExpense(index);
                        },
                        child: ListTile(
                          title: Text(expense['title']),
                          subtitle: Text(
                              '${DateFormat('dd/MM/yyyy').format(expense['date'])} • ${expense['category']}'),
                          trailing: Text(
                            '₹${expense['amount'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EditBudgetScreen extends StatelessWidget {
  final double budget;

  const EditBudgetScreen({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final budgetController = TextEditingController(text: budget.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monthly Budget',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedBudget = double.tryParse(budgetController.text);
                if (updatedBudget != null) {
                  Navigator.of(context).pop(updatedBudget);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
