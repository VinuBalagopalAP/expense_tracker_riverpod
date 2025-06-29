// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentGroupDetailHash() =>
    r'ac91bd6f28315a653f7fd9f9277ed48d5e713490';

/// See also [currentGroupDetail].
@ProviderFor(currentGroupDetail)
final currentGroupDetailProvider = AutoDisposeProvider<Group?>.internal(
  currentGroupDetail,
  name: r'currentGroupDetailProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentGroupDetailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentGroupDetailRef = AutoDisposeProviderRef<Group?>;
String _$groupsNotifierHash() => r'9b540cde749c9d8eb129c7d4b8181589f5b9d11b';

/// See also [GroupsNotifier].
@ProviderFor(GroupsNotifier)
final groupsNotifierProvider =
    AutoDisposeNotifierProvider<GroupsNotifier, List<Group>>.internal(
      GroupsNotifier.new,
      name: r'groupsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$groupsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GroupsNotifier = AutoDisposeNotifier<List<Group>>;
String _$currentGroupNotifierHash() =>
    r'b52e8ab57612cddac9296e0272803ca1e118a724';

/// See also [CurrentGroupNotifier].
@ProviderFor(CurrentGroupNotifier)
final currentGroupNotifierProvider =
    AutoDisposeNotifierProvider<CurrentGroupNotifier, String?>.internal(
      CurrentGroupNotifier.new,
      name: r'currentGroupNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentGroupNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentGroupNotifier = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
