// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupExpensesHash() => r'231ac7fc2bd983764b0fcc7b4ccd9814ab8bab10';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [groupExpenses].
@ProviderFor(groupExpenses)
const groupExpensesProvider = GroupExpensesFamily();

/// See also [groupExpenses].
class GroupExpensesFamily extends Family<List<Expense>> {
  /// See also [groupExpenses].
  const GroupExpensesFamily();

  /// See also [groupExpenses].
  GroupExpensesProvider call(String groupId) {
    return GroupExpensesProvider(groupId);
  }

  @override
  GroupExpensesProvider getProviderOverride(
    covariant GroupExpensesProvider provider,
  ) {
    return call(provider.groupId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'groupExpensesProvider';
}

/// See also [groupExpenses].
class GroupExpensesProvider extends AutoDisposeProvider<List<Expense>> {
  /// See also [groupExpenses].
  GroupExpensesProvider(String groupId)
    : this._internal(
        (ref) => groupExpenses(ref as GroupExpensesRef, groupId),
        from: groupExpensesProvider,
        name: r'groupExpensesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$groupExpensesHash,
        dependencies: GroupExpensesFamily._dependencies,
        allTransitiveDependencies:
            GroupExpensesFamily._allTransitiveDependencies,
        groupId: groupId,
      );

  GroupExpensesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  Override overrideWith(
    List<Expense> Function(GroupExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupExpensesProvider._internal(
        (ref) => create(ref as GroupExpensesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Expense>> createElement() {
    return _GroupExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupExpensesProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GroupExpensesRef on AutoDisposeProviderRef<List<Expense>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupExpensesProviderElement
    extends AutoDisposeProviderElement<List<Expense>>
    with GroupExpensesRef {
  _GroupExpensesProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupExpensesProvider).groupId;
}

String _$groupTotalExpensesHash() =>
    r'f75d776dcc71713dbe04978129245ae2e7ee7ebd';

/// See also [groupTotalExpenses].
@ProviderFor(groupTotalExpenses)
const groupTotalExpensesProvider = GroupTotalExpensesFamily();

/// See also [groupTotalExpenses].
class GroupTotalExpensesFamily extends Family<double> {
  /// See also [groupTotalExpenses].
  const GroupTotalExpensesFamily();

  /// See also [groupTotalExpenses].
  GroupTotalExpensesProvider call(String groupId) {
    return GroupTotalExpensesProvider(groupId);
  }

  @override
  GroupTotalExpensesProvider getProviderOverride(
    covariant GroupTotalExpensesProvider provider,
  ) {
    return call(provider.groupId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'groupTotalExpensesProvider';
}

/// See also [groupTotalExpenses].
class GroupTotalExpensesProvider extends AutoDisposeProvider<double> {
  /// See also [groupTotalExpenses].
  GroupTotalExpensesProvider(String groupId)
    : this._internal(
        (ref) => groupTotalExpenses(ref as GroupTotalExpensesRef, groupId),
        from: groupTotalExpensesProvider,
        name: r'groupTotalExpensesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$groupTotalExpensesHash,
        dependencies: GroupTotalExpensesFamily._dependencies,
        allTransitiveDependencies:
            GroupTotalExpensesFamily._allTransitiveDependencies,
        groupId: groupId,
      );

  GroupTotalExpensesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  Override overrideWith(
    double Function(GroupTotalExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupTotalExpensesProvider._internal(
        (ref) => create(ref as GroupTotalExpensesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _GroupTotalExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupTotalExpensesProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GroupTotalExpensesRef on AutoDisposeProviderRef<double> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupTotalExpensesProviderElement
    extends AutoDisposeProviderElement<double>
    with GroupTotalExpensesRef {
  _GroupTotalExpensesProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupTotalExpensesProvider).groupId;
}

String _$groupBalancesHash() => r'a2025710859f56d9ef1954c9a14ae5419008fb4d';

/// See also [groupBalances].
@ProviderFor(groupBalances)
const groupBalancesProvider = GroupBalancesFamily();

/// See also [groupBalances].
class GroupBalancesFamily extends Family<List<Balance>> {
  /// See also [groupBalances].
  const GroupBalancesFamily();

  /// See also [groupBalances].
  GroupBalancesProvider call(String groupId) {
    return GroupBalancesProvider(groupId);
  }

  @override
  GroupBalancesProvider getProviderOverride(
    covariant GroupBalancesProvider provider,
  ) {
    return call(provider.groupId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'groupBalancesProvider';
}

/// See also [groupBalances].
class GroupBalancesProvider extends AutoDisposeProvider<List<Balance>> {
  /// See also [groupBalances].
  GroupBalancesProvider(String groupId)
    : this._internal(
        (ref) => groupBalances(ref as GroupBalancesRef, groupId),
        from: groupBalancesProvider,
        name: r'groupBalancesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$groupBalancesHash,
        dependencies: GroupBalancesFamily._dependencies,
        allTransitiveDependencies:
            GroupBalancesFamily._allTransitiveDependencies,
        groupId: groupId,
      );

  GroupBalancesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  Override overrideWith(
    List<Balance> Function(GroupBalancesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupBalancesProvider._internal(
        (ref) => create(ref as GroupBalancesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Balance>> createElement() {
    return _GroupBalancesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupBalancesProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GroupBalancesRef on AutoDisposeProviderRef<List<Balance>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupBalancesProviderElement
    extends AutoDisposeProviderElement<List<Balance>>
    with GroupBalancesRef {
  _GroupBalancesProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupBalancesProvider).groupId;
}

String _$expensesNotifierHash() => r'be995fac40191346355c0cfba9837160f6f70e59';

/// See also [ExpensesNotifier].
@ProviderFor(ExpensesNotifier)
final expensesNotifierProvider =
    AutoDisposeNotifierProvider<ExpensesNotifier, List<Expense>>.internal(
      ExpensesNotifier.new,
      name: r'expensesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$expensesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExpensesNotifier = AutoDisposeNotifier<List<Expense>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
