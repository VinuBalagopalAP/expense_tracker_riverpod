import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group.dart';
import '../providers/group_provider.dart';
import 'create_group_screen.dart';
import 'groups_list_screen.dart';
import 'add_expense_screen.dart';
import 'all_expenses_screen.dart';
import 'all_balances_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.group), text: 'Groups'),
              Tab(icon: Icon(Icons.receipt_long), text: 'All Expenses'),
              Tab(
                icon: Icon(Icons.account_balance_wallet),
                text: 'All Balances',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GroupsListScreen(),
            AllExpensesScreen(),
            AllBalancesScreen(),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            // Get the current tab index safely
            final tabController = DefaultTabController.of(context);

            final tabIndex = tabController.index;
            return tabIndex == 0
                ? FloatingActionButton(
                    onPressed: () {
                      _showAddOptions(context, ref);
                    },
                    child: const Icon(Icons.add),
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  static void _showAddOptions(BuildContext context, WidgetRef ref) {
    final groups = ref.read(groupsNotifierProvider);

    if (groups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No groups available. Create a group first!'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'What would you like to add?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Add Expense'),
              subtitle: Text(
                groups.length == 1
                    ? 'Add expense to ${groups.first.name}'
                    : 'Add expense to a group',
              ),
              enabled: groups.isNotEmpty,
              onTap: groups.length == 1
                  ? () => _navigateToAddExpense(context, groups.first.id)
                  : () => _showGroupSelectionDialog(context, ref, groups),
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Create Group'),
              subtitle: const Text('Start a new expense group'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateGroupScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static void _showGroupSelectionDialog(
    BuildContext context,
    WidgetRef ref,
    List<Group> groups,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Group'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return ListTile(
                leading: CircleAvatar(child: Icon(group.type.icon)),
                title: Text(group.name),
                subtitle: Text('${group.memberIds.length} members'),
                onTap: () {
                  Navigator.of(context).pop();
                  ref
                      .read(currentGroupNotifierProvider.notifier)
                      .setCurrentGroup(group.id);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddExpenseScreen(groupId: group.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static void _navigateToAddExpense(BuildContext context, String groupId) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(groupId: groupId),
      ),
    );
  }
}
