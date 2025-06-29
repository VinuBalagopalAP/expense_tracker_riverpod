import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/group.dart';
import '../models/user.dart';
import '../providers/expense_provider.dart';
import '../providers/group_provider.dart';
import '../providers/user_provider.dart';

class AllBalancesScreen extends ConsumerWidget {
  const AllBalancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsNotifierProvider);
    final users = ref.watch(usersNotifierProvider);

    if (groups.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No groups yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Create a group to start tracking balances',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final balances = ref.watch(groupBalancesProvider(group.id));

        return Card(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGroupHeader(group, balances),
              if (balances.isNotEmpty)
                ...balances.map((balance) => _buildBalanceTile(balance, users))
              else
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'All settled up! 🎉',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGroupHeader(Group group, List<dynamic> balances) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getGroupColor(group.type).withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Icon(group.type.icon, color: _getGroupColor(group.type)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${group.memberIds.length} members',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (balances.isEmpty)
            _buildStatusBadge('Settled', Colors.green)
          else
            _buildStatusBadge(
              '${balances.length} debt${balances.length == 1 ? '' : 's'}',
              Colors.orange,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildBalanceTile(dynamic balance, List<User> users) {
    final user1 = users.firstWhere(
      (user) => user.id == balance.userId1,
      orElse: () => User(id: '', name: 'Unknown', email: ''),
    );
    final user2 = users.firstWhere(
      (user) => user.id == balance.userId2,
      orElse: () => User(id: '', name: 'Unknown', email: ''),
    );

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orange,
        radius: 16,
        child: Text(
          user1.name.isNotEmpty ? user1.name[0].toUpperCase() : '?',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      title: Text(
        '${user1.name} owes ${user2.name}',
        style: const TextStyle(fontSize: 14),
      ),
      trailing: Text(
        '\$${balance.amount.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
    );
  }

  Color _getGroupColor(GroupType? type) {
    switch (type) {
      case GroupType.general:
        return Colors.blue;
      case GroupType.trip:
        return Colors.purple;
      case GroupType.home:
        return Colors.green;
      case GroupType.couple:
        return Colors.pink;
      case GroupType.other:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
