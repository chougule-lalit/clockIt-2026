// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeTasksStreamHash() => r'a6c1aa9a878c49ff7675e611716965d4cff839c0';

/// Watches all active (non-completed) tasks in real time.
///
/// Copied from [activeTasksStream].
@ProviderFor(activeTasksStream)
final activeTasksStreamProvider =
    AutoDisposeStreamProvider<List<TaskItem>>.internal(
      activeTasksStream,
      name: r'activeTasksStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeTasksStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveTasksStreamRef = AutoDisposeStreamProviderRef<List<TaskItem>>;
String _$allTasksStreamHash() => r'aca50a86d2f0f7ef24512e83c522c9de7531a89c';

/// Watches ALL tasks (active + completed) in real time.
///
/// Copied from [allTasksStream].
@ProviderFor(allTasksStream)
final allTasksStreamProvider =
    AutoDisposeStreamProvider<List<TaskItem>>.internal(
      allTasksStream,
      name: r'allTasksStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allTasksStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllTasksStreamRef = AutoDisposeStreamProviderRef<List<TaskItem>>;
String _$taskNotifierHash() => r'c2432b2e25081f766154825cbd7797b76c6fba98';

/// Manages task mutations and runs smart rollover on first build.
///
/// Copied from [TaskNotifier].
@ProviderFor(TaskNotifier)
final taskNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TaskNotifier, void>.internal(
      TaskNotifier.new,
      name: r'taskNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$taskNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
