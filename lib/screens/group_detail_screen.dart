import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group.dart';
import '../providers/expense_provider.dart';
import '../providers/group_provider.dart';
import 'group_expenses_screen.dart';
import 'group_balances_screen.dart';
import 'group_members_screen.dart';
import 'add_expense_screen.dart';

class GroupDetailScreen extends ConsumerWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref
        .watch(groupsNotifierProvider)
        .firstWhere(
          (g) => g.id == groupId,
          orElse: () => Group(
            id: '',
            name: 'Group Not Found',
            description: '',
            memberIds: [],
            createdBy: '',
            createdAt: DateTime.now(),
          ),
        );

    if (group.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Group Not Found')),
        body: const Center(child: Text('This group no longer exists')),
      );
    }

    final totalExpenses = ref.watch(groupTotalExpensesProvider(groupId));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.name),
              Text(
                '₹${totalExpenses.toStringAsFixed(2)} total',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.receipt_long), text: 'Expenses'),
              Tab(icon: Icon(Icons.account_balance_wallet), text: 'Balances'),
              Tab(icon: Icon(Icons.people), text: 'Members'),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              tooltip: 'More options',
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditGroupDialog(context, ref, group);
                    break;
                  case 'leave':
                    _showLeaveGroupDialog(context, ref, group);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Group'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'leave',
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.red),
                    title: Text('Leave Group'),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: TabBarView(
          children: [
            GroupExpensesScreen(groupId: groupId),
            GroupBalancesScreen(groupId: groupId),
            GroupMembersScreen(groupId: groupId),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Expense',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddExpenseScreen(groupId: groupId),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context, WidgetRef ref, Group group) {
    final nameController = TextEditingController(text: group.name);
    final descriptionController = TextEditingController(
      text: group.description,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Group Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameController.text.trim();
              final newDescription = descriptionController.text.trim();

              if (newName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group name cannot be empty')),
                );
                return;
              }

              final updatedGroup = group.copyWith(
                name: newName,
                description: newDescription,
              );

              ref
                  .read(groupsNotifierProvider.notifier)
                  .updateGroup(updatedGroup);

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Group updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLeaveGroupDialog(BuildContext context, WidgetRef ref, Group group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Group'),
        content: Text('Are you sure you want to leave "${group.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Remove current user from the group in the actual app.
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You left the group')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}
