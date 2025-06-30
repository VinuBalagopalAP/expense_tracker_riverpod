import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/balance.dart';
import '../models/expense.dart';
import '../models/group.dart';
import 'expense_provider.dart';
import 'group_provider.dart';

part 'balance_provider.g.dart';

@riverpod
class BalanceNotifier extends _$BalanceNotifier {
  @override
  List<Balance> build() {
    return [];
  }

  void updateBalances(List<Expense> expenses, Group group) {
    final Map<String, double> balances = {};

    for (final expense in expenses) {
      final shares = expense.getIndividualShares();

      // Deduct shares for each user
      for (final userId in shares.keys) {
        balances[userId] = (balances[userId] ?? 0) - shares[userId]!;
      }

      // Add the paid amount to the payer's balance
      balances[expense.paidBy] =
          (balances[expense.paidBy] ?? 0) + expense.amount;
    }

    // Convert to a list of `Balance` objects
    final List<Balance> balanceList = [];
    for (final entry in balances.entries) {
      balanceList.add(
        Balance(
          userId1: entry.key,
          userId2: '', // Can be extended for specific pair balances
          amount: entry.value,
          groupId: group.id, // Include group ID for context
        ),
      );
    }

    state = balanceList;
  }
}

@riverpod
List<Balance> groupBalances(ref, String groupId) {
  final expenses = ref.watch(groupExpensesProvider(groupId));
  final group = ref
      .watch(groupsNotifierProvider)
      .firstWhere((g) => g.id == groupId, orElse: () => Group.empty());

  // Calculate balances directly instead of using the notifier
  final Map<String, double> balances = {};

  for (final expense in expenses) {
    final shares = expense.getIndividualShares();

    for (final userId in shares.keys) {
      balances[userId] = (balances[userId] ?? 0) - shares[userId]!;
    }

    balances[expense.paidBy] = (balances[expense.paidBy] ?? 0) + expense.amount;
  }

  return balances.entries
      .map(
        (entry) => Balance(
          userId1: entry.key,
          userId2: '', // Can be extended for specific pair balances
          amount: entry.value,
          groupId: group.id,
        ),
      )
      .toList();
}
