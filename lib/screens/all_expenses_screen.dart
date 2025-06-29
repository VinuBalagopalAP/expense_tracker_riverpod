import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expense.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../providers/expense_provider.dart';
import '../providers/group_provider.dart';
import '../providers/user_provider.dart';

class AllExpensesScreen extends ConsumerWidget {
  const AllExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesNotifierProvider);
    final users = ref.watch(usersNotifierProvider);
    final groups = ref.watch(groupsNotifierProvider);

    if (expenses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No expenses yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Create a group and add your first expense',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Group expenses by date
    final groupedExpenses = <String, List<Expense>>{};
    for (final expense in expenses) {
      final dateKey =
          '${expense.date.day}/${expense.date.month}/${expense.date.year}';
      groupedExpenses[dateKey] ??= [];
      groupedExpenses[dateKey]!.add(expense);
    }

    final sortedDates = groupedExpenses.keys.toList()
      ..sort((a, b) {
        final dateA = groupedExpenses[a]!.first.date;
        final dateB = groupedExpenses[b]!.first.date;
        return dateB.compareTo(dateA); // Most recent first
      });

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final dayExpenses = groupedExpenses[dateKey]!;
        final totalForDay = dayExpenses.fold(0.0, (sum, e) => sum + e.amount);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDateHeader(dayExpenses.first.date),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${totalForDay.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ...dayExpenses.map((expense) {
              final paidByUser = users.firstWhere(
                (user) => user.id == expense.paidBy,
                orElse: () => User(id: '', name: 'Unknown', email: ''),
              );
              final group = groups.firstWhere(
                (g) => g.id == expense.groupId,
                orElse: () => Group(
                  id: '',
                  name: 'Unknown Group',
                  description: '',
                  memberIds: [],
                  createdBy: '',
                  createdAt: DateTime.now(),
                ),
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      '\$${expense.amount.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  title: Text(expense.description),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${group.name} • Paid by ${paidByUser.name}'),
                      Text(
                        'Split between ${expense.splitBetween.length} people',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Text(
                    '\$${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () =>
                      _showExpenseDetails(context, expense, users, group),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final expenseDate = DateTime(date.year, date.month, date.day);

    if (expenseDate == today) {
      return 'Today';
    } else if (expenseDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showExpenseDetails(
    BuildContext context,
    Expense expense,
    List<User> users,
    Group group,
  ) {
    final paidByUser = users.firstWhere((user) => user.id == expense.paidBy);
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
              Text('Group: ${group.name}'),
              Text('Total Amount: \$${expense.amount.toStringAsFixed(2)}'),
              Text('Paid by: ${paidByUser.name}'),
              Text(
                'Date: ${expense.date.day}/${expense.date.month}/${expense.date.year}',
              ),
              if (expense.category != null)
                Text('Category: ${expense.category}'),
              if (expense.notes != null && expense.notes!.isNotEmpty)
                Text('Notes: ${expense.notes}'),
              const SizedBox(height: 16),
              const Text(
                'Split Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...participantUsers.map(
                (user) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(user.name),
                      Text(
                        '\$${shares[user.id]?.toStringAsFixed(2) ?? "0.00"}',
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
