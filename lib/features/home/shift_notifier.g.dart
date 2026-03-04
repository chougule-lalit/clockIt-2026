// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayShiftStreamHash() => r'803c8634da0384102ca1cd8d40e1ac995d7f6b07';

/// Watches today's shift live from the database (for reactive UI rebuilds).
///
/// Copied from [todayShiftStream].
@ProviderFor(todayShiftStream)
final todayShiftStreamProvider =
    AutoDisposeStreamProvider<DailyShift?>.internal(
      todayShiftStream,
      name: r'todayShiftStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayShiftStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayShiftStreamRef = AutoDisposeStreamProviderRef<DailyShift?>;
String _$shiftNotifierHash() => r'c1677a21a762c5aacdd7eae54b002dde5b624501';

/// See also [ShiftNotifier].
@ProviderFor(ShiftNotifier)
final shiftNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ShiftNotifier, ShiftState>.internal(
      ShiftNotifier.new,
      name: r'shiftNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shiftNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ShiftNotifier = AutoDisposeAsyncNotifier<ShiftState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
