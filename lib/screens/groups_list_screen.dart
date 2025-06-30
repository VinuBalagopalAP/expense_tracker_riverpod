import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group.dart';
import '../providers/group_provider.dart';
import 'create_group_screen.dart';
import 'group_detail_screen.dart';

class GroupsListScreen extends ConsumerWidget {
  const GroupsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsNotifierProvider);
    final currentGroupId = ref.watch(currentGroupNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: groups.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_add, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No groups yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your first group to start tracking expenses',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                // You could add refresh logic here if needed
                ref.invalidate(groupsNotifierProvider);
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  final isCurrentGroup = group.id == currentGroupId;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: isCurrentGroup ? 4 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isCurrentGroup
                          ? BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            )
                          : BorderSide.none,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: _getGroupColor(group.type),
                        child: Icon(group.type.icon, color: Colors.white),
                      ),
                      title: Text(
                        group.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            group.description.isNotEmpty
                                ? group.description
                                : 'No description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${group.memberIds.length} members',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        ref
                            .read(currentGroupNotifierProvider.notifier)
                            .setCurrentGroup(group.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GroupDetailScreen(groupId: group.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getGroupColor(GroupType type) {
    const colorMap = {
      GroupType.general: Colors.blue,
      GroupType.trip: Colors.purple,
      GroupType.home: Colors.green,
      GroupType.couple: Colors.pink,
      GroupType.other: Colors.grey,
    };
    return colorMap[type] ?? Colors.grey;
  }
}
