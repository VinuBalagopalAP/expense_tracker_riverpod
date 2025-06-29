import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user.dart';

part 'user_provider.g.dart';

@riverpod
class UsersNotifier extends _$UsersNotifier {
  @override
  List<User> build() {
    return [
      User(id: '1', name: 'John Doe', email: 'john@example.com'),
      User(id: '2', name: 'Jane Smith', email: 'jane@example.com'),
      User(id: '3', name: 'Bob Johnson', email: 'bob@example.com'),
    ];
  }

  void addUser(User user) {
    if (state.any((existingUser) => existingUser.id == user.id)) {
      throw Exception('User with ID ${user.id} already exists.');
    }
    state = [...state, user];
  }

  void removeUser(String userId) {
    if (!state.any((user) => user.id == userId)) {
      throw Exception('User with ID $userId does not exist.');
    }
    state = state.where((user) => user.id != userId).toList();
  }

  void updateUser(User updatedUser) {
    bool userExists = state.any((user) => user.id == updatedUser.id);
    if (!userExists) {
      throw Exception('User with ID ${updatedUser.id} does not exist.');
    }
    state = state
        .map((user) => user.id == updatedUser.id ? updatedUser : user)
        .toList();
  }

  List<User> searchUsers(String query) {
    return state
        .where(
          (user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  User? getUserById(String userId) {
    try {
      return state.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }
}
