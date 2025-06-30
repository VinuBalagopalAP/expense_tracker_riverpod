import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import '../models/user.dart';
import '../providers/expense_provider.dart';
import '../providers/user_provider.dart';

class GroupExpensesScreen extends ConsumerWidget {
  final String groupId;

  const GroupExpensesScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(groupExpensesProvider(groupId));
    final users = ref.watch(usersNotifierProvider);

    if (expenses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No expenses in this group yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first expense to get started',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        final paidByUser = users.firstWhere(
          (user) => user.id == expense.paidBy,
          orElse: () => User(id: '', name: 'Unknown', email: ''),
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(
                '₹${expense.amount.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            title: Text(expense.description),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Paid by: ${paidByUser.name}'),
                Text(
                  'Split among ${expense.splitBetween.length} people',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (expense.category != null)
                  Text(
                    'Category: ${expense.category}',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '₹${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('dd MMM').format(expense.date),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            onTap: () => _showExpenseDetails(context, expense, users),
          ),
        );
      },
    );
  }

  void _showExpenseDetails(
    BuildContext context,
    Expense expense,
    List<User> users,
  ) {
    final paidByUser = users.firstWhere(
      (user) => user.id == expense.paidBy,
      orElse: () => User(id: '', name: 'Unknown', email: ''),
    );
    final participantUsers = users
        .where((user) => expense.splitBetween.contains(user.id))
        .toList();
    final shares = expense.getIndividualShares();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense.description),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Amount: ₹${expense.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Paid by: ${paidByUser.name}'),
              Text('Date: ${DateFormat('dd MMM yyyy').format(expense.date)}'),
              if (expense.category != null)
                Text('Category: ${expense.category}'),
              if (expense.notes != null && expense.notes!.isNotEmpty)
                Text('Notes: ${expense.notes}'),
              const SizedBox(height: 16),
              const Text(
                'Split Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...participantUsers.map(
                (user) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(user.name),
                      Text(
                        '₹${shares[user.id]?.toStringAsFixed(2) ?? "0.00"}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
