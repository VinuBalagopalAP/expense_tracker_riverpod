import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/balance.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../providers/balance_provider.dart';
import '../providers/group_provider.dart';
import '../providers/user_provider.dart';

class AllBalancesScreen extends ConsumerWidget {
  const AllBalancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsNotifierProvider);
    final users = ref.watch(usersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Balances'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(groupsNotifierProvider);
              ref.invalidate(usersNotifierProvider);
            },
          ),
        ],
      ),
      body: groups.isEmpty
          ? const Center(child: EmptyGroupsState())
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, groupIndex) {
                final group = groups[groupIndex];
                final balances = ref.watch(groupBalancesProvider(group.id));

                return GroupBalanceCard(
                  group: group,
                  balances: balances,
                  users: users,
                );
              },
            ),
    );
  }
}

class GroupBalanceCard extends StatelessWidget {
  final Group group;
  final List<Balance> balances;
  final List<User> users;

  const GroupBalanceCard({
    super.key,
    required this.group,
    required this.balances,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    // Filter only balances where amount != 0
    final nonZeroBalances = balances.where((b) => b.amount != 0).toList();

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupHeader(group: group, balanceCount: nonZeroBalances.length),
          if (nonZeroBalances.isNotEmpty)
            ...nonZeroBalances.map(
              (balance) => BalanceTile(balance: balance, users: users),
            ),
          if (nonZeroBalances.isEmpty) const SettledStatusIndicator(),
        ],
      ),
    );
  }
}

class GroupHeader extends StatelessWidget {
  final Group group;
  final int balanceCount;

  const GroupHeader({
    super.key,
    required this.group,
    required this.balanceCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: group.type.color.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Icon(group.type.icon, color: group.type.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${group.memberIds.length} members',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          BalanceStatusBadge(isSettled: balanceCount == 0, count: balanceCount),
        ],
      ),
    );
  }
}

class BalanceTile extends StatelessWidget {
  final Balance balance;
  final List<User> users;

  const BalanceTile({super.key, required this.balance, required this.users});

  @override
  Widget build(BuildContext context) {
    final user1 = users.firstWhere(
      (user) => user.id == balance.userId1,
      orElse: () => User(id: '', name: '', email: ''),
    );
    final user2 = users.firstWhere(
      (user) => user.id == balance.userId2,
      orElse: () => User(id: '', name: '', email: ''),
    );

    final isPositive = balance.amount > 0;
    final amountText = '₹${balance.amount.abs().toStringAsFixed(2)}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: UserAvatar(user: isPositive ? user1 : user2),
            title: Text(
              isPositive
                  ? '${user2.name} owes ${user1.name}'
                  : '${user1.name} owes ${user2.name}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Text(
              amountText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final User user;

  const UserAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.blue[100],
      radius: 20,
      child: Text(
        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class BalanceStatusBadge extends StatelessWidget {
  final bool isSettled;
  final int count;

  const BalanceStatusBadge({
    super.key,
    required this.isSettled,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSettled ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        isSettled ? 'Settled' : '$count debt${count == 1 ? '' : 's'}',
        style: TextStyle(
          color: isSettled ? Colors.green[800] : Colors.orange[800],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SettledStatusIndicator extends StatelessWidget {
  const SettledStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'All settled up!',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyGroupsState extends StatelessWidget {
  const EmptyGroupsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No groups yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a group to start tracking balances',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
