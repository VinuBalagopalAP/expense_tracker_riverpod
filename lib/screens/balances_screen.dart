import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/balance.dart';
import '../models/expense.dart';
import '../models/user.dart';
import '../providers/expense_provider.dart';
import '../providers/balance_provider.dart';
import '../providers/user_provider.dart';

class BalancesScreen extends ConsumerWidget {
  const BalancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balances = ref.watch(balanceNotifierProvider);
    final users = ref.watch(usersNotifierProvider);

    if (balances.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'All settled up!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'No outstanding balances',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: balances.length,
      itemBuilder: (context, index) {
        final balance = balances[index];
        final user1 = users.firstWhere(
          (user) => user.id == balance.userId1,
          orElse: () => User(id: '', name: 'Unknown', email: ''),
        );
        final user2 = users.firstWhere(
          (user) => user.id == balance.userId2,
          orElse: () => User(id: '', name: 'Unknown', email: ''),
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                user1.name.isNotEmpty ? user1.name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text('${user1.name} owes ${user2.name}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '₹${balance.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onTap: () =>
                _showSettleUpDialog(context, balance, user1, user2, ref),
          ),
        );
      },
    );
  }

  void _showSettleUpDialog(
    BuildContext context,
    Balance balance,
    User user1,
    User user2,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settle Up'),
        content: Text(
          '${user1.name} owes ${user2.name} ₹${balance.amount.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add a settlement expense
              final expense = Expense(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                description: 'Settlement: ${user1.name} pays ${user2.name}',
                amount: balance.amount,
                paidBy: user1.id,
                splitBetween: [user1.id],
                date: DateTime.now(),
                groupId: balance.groupId,
              );
              ref.read(expensesNotifierProvider.notifier).addExpense(expense);
              Navigator.of(context).pop();
            },
            child: const Text('Mark as Settled'),
          ),
        ],
      ),
    );
  }
}
