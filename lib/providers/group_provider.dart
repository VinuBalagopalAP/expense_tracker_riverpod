import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/group.dart';

part 'group_provider.g.dart';

@riverpod
class GroupsNotifier extends _$GroupsNotifier {
  @override
  List<Group> build() {
    return [
      Group(
        id: 'default',
        name: 'Personal Expenses',
        description: 'Default group for personal expenses',
        memberIds: ['1', '2', '3'],
        createdBy: '1',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        type: GroupType.general,
      ),
      Group(
        id: 'trip1',
        name: 'Europe Trip 2024',
        description: 'Our amazing European adventure',
        memberIds: ['1', '2'],
        createdBy: '1',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        type: GroupType.trip,
      ),
    ];
  }

  void addGroup(Group group) {
    if (state.any((existingGroup) => existingGroup.id == group.id)) {
      throw Exception('Group with ID ${group.id} already exists.');
    }
    state = [...state, group];
  }

  void removeGroup(String groupId) {
    if (!state.any((group) => group.id == groupId)) {
      throw Exception('Group with ID $groupId does not exist.');
    }
    state = state.where((group) => group.id != groupId).toList();
  }

  void updateGroup(Group updatedGroup) {
    bool groupExists = state.any((group) => group.id == updatedGroup.id);
    if (!groupExists) {
      throw Exception('Group with ID ${updatedGroup.id} does not exist.');
    }
    state = state
        .map((group) => group.id == updatedGroup.id ? updatedGroup : group)
        .toList();
  }

  void addMemberToGroup(String groupId, String userId) {
    state = state.map((group) {
      if (group.id == groupId) {
        if (group.memberIds.contains(userId)) {
          throw Exception(
            'User with ID $userId is already a member of group $groupId.',
          );
        }
        return group.copyWith(memberIds: [...group.memberIds, userId]);
      }
      return group;
    }).toList();
  }

  void removeMemberFromGroup(String groupId, String userId) {
    state = state.map((group) {
      if (group.id == groupId) {
        if (!group.memberIds.contains(userId)) {
          throw Exception(
            'User with ID $userId is not a member of group $groupId.',
          );
        }
        return group.copyWith(
          memberIds: group.memberIds.where((id) => id != userId).toList(),
        );
      }
      return group;
    }).toList();
  }

  List<Group> filterGroupsByType(GroupType type) {
    return state.where((group) => group.type == type).toList();
  }

  List<Group> searchGroups(String query) {
    return state
        .where(
          (group) =>
              group.name.toLowerCase().contains(query.toLowerCase()) ||
              group.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}

@riverpod
class CurrentGroupNotifier extends AutoDisposeNotifier<String?> {
  @override
  String? build() => null;

  void setCurrentGroup(String? groupId) {
    state = groupId;
  }
}

@riverpod
Group? currentGroupDetail(ref) {
  final currentGroupId = ref.watch(currentGroupNotifierProvider);
  final groups = ref.watch(groupsNotifierProvider);

  if (currentGroupId == null) return null;

  try {
    return groups.firstWhere((group) => group.id == currentGroupId);
  } catch (e) {
    return null;
  }
}
