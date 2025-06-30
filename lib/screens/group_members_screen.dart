import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/group.dart';
import '../models/user.dart';
import '../providers/expense_provider.dart';
import '../providers/group_provider.dart';
import '../providers/user_provider.dart';

class GroupMembersScreen extends ConsumerWidget {
  final String groupId;

  const GroupMembersScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref
        .watch(groupsNotifierProvider)
        .firstWhere((g) => g.id == groupId);
    final users = ref.watch(usersNotifierProvider);
    final members = users
        .where((user) => group.memberIds.contains(user.id))
        .toList();
    final expenses = ref.watch(groupExpensesProvider(groupId));

    return Column(
      children: [
        _buildHeader(context, ref, group, users),
        Expanded(
          child: ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              final isCreator = member.id == group.createdBy;
              return _buildMemberTile(
                context,
                member,
                isCreator,
                expenses,
                group,
                ref,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    Group group,
    List<User> users,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Group Members (${group.memberIds.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Created ${_formatDate(group.createdAt)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showAddMemberDialog(context, ref, group, users),
            icon: const Icon(Icons.person_add),
            label: const Text('Add Member'),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(
    BuildContext context,
    User member,
    bool isCreator,
    List expenses,
    Group group,
    WidgetRef ref,
  ) {
    final memberExpenses = expenses.where((e) => e.paidBy == member.id).length;
    final totalPaid = expenses
        .where((e) => e.paidBy == member.id)
        .fold(0.0, (sum, e) => sum + e.amount);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: isCreator
                  ? const Color(0xFFFFD700)
                  : Colors.blue,
              child: Text(
                member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            if (isCreator)
              Positioned(
                bottom: 0,
                right: 0,
                child: const Icon(Icons.star, size: 16, color: Colors.white),
              ),
          ],
        ),
        title: Row(
          children: [
            Text(member.name.isNotEmpty ? member.name : 'Unknown User'),
            if (isCreator) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ADMIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.email.isNotEmpty ? member.email : 'No Email Provided'),
            const SizedBox(height: 4),
            Text(
              '$memberExpenses expenses • ₹${totalPaid.toStringAsFixed(2)} paid',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: !isCreator
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'remove') {
                    _showRemoveMemberDialog(context, ref, group, member);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'remove',
                    child: ListTile(
                      leading: Icon(Icons.remove_circle, color: Colors.red),
                      title: Text('Remove from group'),
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  void _showAddMemberDialog(
    BuildContext context,
    WidgetRef ref,
    Group group,
    List<User> users,
  ) {
    final availableUsers = users
        .where((user) => !group.memberIds.contains(user.id))
        .toList();

    if (availableUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All users are already in this group')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Member'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableUsers.length,
            itemBuilder: (context, index) {
              final user = availableUsers[index];
              return ListTile(
                leading: CircleAvatar(child: Text(user.name[0].toUpperCase())),
                title: Text(user.name),
                subtitle: Text(user.email),
                onTap: () {
                  ref
                      .read(groupsNotifierProvider.notifier)
                      .addMemberToGroup(group.id, user.id);
                  Navigator.of(context).pop();
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

  void _showRemoveMemberDialog(
    BuildContext context,
    WidgetRef ref,
    Group group,
    User member,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
          'Are you sure you want to remove ${member.name} from this group?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(groupsNotifierProvider.notifier)
                  .removeMemberFromGroup(group.id, member.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
