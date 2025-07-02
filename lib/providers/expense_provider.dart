import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/expense.dart';
import '../models/balance.dart';
import '../models/group.dart';
import '../models/user.dart';
import 'user_provider.dart';
import 'group_provider.dart';

part 'expense_provider.g.dart';

@riverpod
class ExpensesNotifier extends _$ExpensesNotifier {
  @override
  List<Expense> build() {
    return [];
  }

  void addExpense(Expense expense) {
    state = [...state, expense];
  }

  void removeExpense(String expenseId) {
    state = state.where((expense) => expense.id != expenseId).toList();
  }
}

@riverpod
List<Expense> groupExpenses(ref, String groupId) {
  final allExpenses = ref.watch(expensesNotifierProvider);
  return allExpenses.where((expense) => expense.groupId == groupId).toList();
}

@riverpod
double groupTotalExpenses(ref, String groupId) {
  final expenses = ref.watch(groupExpensesProvider(groupId));
  return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
}

@riverpod
List<Balance> groupBalances(ref, String groupId) {
  final expenses = ref.watch(groupExpensesProvider(groupId));
  final group = ref
      .watch(groupsNotifierProvider)
      .firstWhere((g) => g.id == groupId, orElse: () => Group.empty());
  final List<User> users = ref.watch(usersNotifierProvider);
  final groupUsers = users
      .where((user) => group.memberIds.contains(user.id))
      .toList();

  return _calculateBalances(expenses, groupUsers);
}

// Helper function to calculate balances
List<Balance> _calculateBalances(List<Expense> expenses, List users) {
  final Map<String, double> balances = {};

  for (final expense in expenses) {
    final shares = expense.getIndividualShares();
    for (final userId in shares.keys) {
      balances[userId] = (balances[userId] ?? 0) - shares[userId]!;
    }
    balances[expense.paidBy] = (balances[expense.paidBy] ?? 0) + expense.amount;
  }

  return balances.entries.map((entry) {
    return Balance(
      userId1: entry.key,
      userId2: '', // This can be expanded based on business logic
      amount: entry.value,
      groupId: '', // Optional group ID for grouping balances
    );
  }).toList();
}
