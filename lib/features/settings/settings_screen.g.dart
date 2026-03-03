// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsNotifierHash() => r'bed9e5326cdae4892e4e473f71fedbe822329068';

/// See also [SettingsNotifier].
@ProviderFor(SettingsNotifier)
final settingsNotifierProvider =
    AutoDisposeNotifierProvider<SettingsNotifier, SettingsFormState>.internal(
      SettingsNotifier.new,
      name: r'settingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SettingsNotifier = AutoDisposeNotifier<SettingsFormState>;
String _$bucketsNotifierHash() => r'd177bfe41062e223b52f20646a210cd177e23012';

/// See also [BucketsNotifier].
@ProviderFor(BucketsNotifier)
final bucketsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      BucketsNotifier,
      List<TimesheetBucket>
    >.internal(
      BucketsNotifier.new,
      name: r'bucketsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bucketsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BucketsNotifier = AutoDisposeAsyncNotifier<List<TimesheetBucket>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
