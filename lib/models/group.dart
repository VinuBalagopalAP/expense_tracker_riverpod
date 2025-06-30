import 'package:flutter/material.dart';

class Group {
  final String id;
  final String name;
  final String description;
  final List<String> memberIds;
  final String createdBy;
  final DateTime createdAt;
  final String? imageUrl;
  final GroupType type;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.createdBy,
    required this.createdAt,
    this.imageUrl,
    this.type = GroupType.general,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      memberIds: List<String>.from(json['memberIds']),
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      imageUrl: json['imageUrl'],
      type: GroupType.values[json['type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'memberIds': memberIds,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
      'type': type.index,
    };
  }

  Group copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? memberIds,
    String? createdBy,
    DateTime? createdAt,
    String? imageUrl,
    GroupType? type,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      memberIds: memberIds ?? this.memberIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
    );
  }

  /// Static method to return an empty Group instance
  static Group empty() {
    return Group(
      id: '',
      name: '',
      description: '',
      memberIds: [],
      createdBy: '',
      createdAt: DateTime.now(),
      imageUrl: null,
      type: GroupType.general,
    );
  }
}

enum GroupType { general, trip, home, couple, other }

extension GroupTypeDisplayName on GroupType {
  String get displayName {
    switch (this) {
      case GroupType.general:
        return 'General';
      case GroupType.trip:
        return 'Trip';
      case GroupType.home:
        return 'Home';
      case GroupType.couple:
        return 'Couple';
      case GroupType.other:
        return 'Other';
    }
  }
}

extension GroupTypeExtension on GroupType {
  IconData get icon {
    switch (this) {
      case GroupType.general:
        return Icons.group;
      case GroupType.trip:
        return Icons.airplane_ticket;
      case GroupType.home:
        return Icons.home;
      case GroupType.couple:
        return Icons.favorite;
      case GroupType.other:
        return Icons.more_horiz;
    }
  }
}
extension GroupTypeColorExtension on GroupType {
  Color get color {
    switch (this) {
      case GroupType.general:
        return Colors.blue;
      case GroupType.trip:
        return Colors.green;
      case GroupType.home:
        return Colors.orange;
      case GroupType.couple:
        return Colors.pink;
      case GroupType.other:
        return Colors.grey;
    }
  }
}