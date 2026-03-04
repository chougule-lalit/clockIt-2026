import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/notification_service.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/shift_repository.dart';
import '../../data/repositories/user_profile_repository.dart';

part 'shift_notifier.g.dart';

// ── State ─────────────────────────────────────────────────────────────────────

/// Immutable state carried by [ShiftNotifier].
class ShiftState {
  const ShiftState({
    required this.shift,
    required this.profile,
    this.expectedLogout,
  });

  final DailyShift shift;
  final UserProfile profile;
  final DateTime? expectedLogout;

  bool get isClockedIn =>
      shift.clockIn != null && shift.clockOut == null;

  bool get isClockedOut =>
      shift.clockIn != null && shift.clockOut != null;

  /// Overtime in hours (positive = overtime, negative = short).
  double? get overtimeDelta => shift.overtime;

  ShiftState copyWith({
    DailyShift? shift,
    UserProfile? profile,
    DateTime? expectedLogout,
  }) {
    return ShiftState(
      shift: shift ?? this.shift,
      profile: profile ?? this.profile,
      expectedLogout: expectedLogout ?? this.expectedLogout,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftState &&
          shift == other.shift &&
          profile == other.profile &&
          expectedLogout == other.expectedLogout;

  @override
  int get hashCode =>
      Object.hash(shift, profile, expectedLogout);
}

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class ShiftNotifier extends _$ShiftNotifier {
  @override
  Future<ShiftState> build() async {
    // 1. Seed default categories if needed.
    final shiftRepo = ref.read(shiftRepositoryProvider);
    await shiftRepo.ensureDefaultCategories();

    // 2. Load (or create) today's shift row.
    final shift = await shiftRepo.getOrCreateTodayShift();

    // 3. Load user profile.
    final profileRepo = ref.read(userProfileRepositoryProvider);
    final profile = await profileRepo.getProfile();

    // Profile should always exist after onboarding; fall back to defaults.
    final safeProfile = profile ??
        const UserProfile(
          id: 0,
          targetWorkHours: 8.0,
          targetBreakHours: 0.75,
          notificationLeadMins: 15,
          defaultStartHour: 9,
          defaultStartMinute: 30,
        );

    final expectedLogout = _calcExpectedLogout(shift, safeProfile);
    return ShiftState(
      shift: shift,
      profile: safeProfile,
      expectedLogout: expectedLogout,
    );
  }

  // ── Public actions ──────────────────────────────────────────────────────────

  /// Clocks the user in right now (or at [time] if provided).
  Future<void> clockIn({DateTime? time}) async {
    final s = await future;
    final now = time ?? DateTime.now();
    final repo = ref.read(shiftRepositoryProvider);
    await repo.clockIn(s.shift.id, now);

    // Reload the shift row.
    final updated = await repo.getOrCreateTodayShift();
    final expectedLogout = _calcExpectedLogout(updated, s.profile);

    // Show a confirmation notification.
    final notifSvc = ref.read(notificationServiceProvider);
    await notifSvc.showClockInConfirmation(
      _formatTime(expectedLogout),
    );

    state = AsyncData(
      s.copyWith(shift: updated, expectedLogout: expectedLogout),
    );
  }

  /// Clocks the user out right now (or at [time] if provided).
  Future<void> clockOut({DateTime? time}) async {
    final s = await future;
    final now = time ?? DateTime.now();
    final repo = ref.read(shiftRepositoryProvider);
    await repo.clockOut(
      s.shift.id,
      now,
      targetWorkHours: s.profile.targetWorkHours,
      targetBreakHours: s.profile.targetBreakHours,
    );

    final updated = await repo.getOrCreateTodayShift();
    final isOvertime = (updated.overtime ?? 0) > 0;
    final hoursStr = _formatHours(updated.actualTotalHours ?? 0);

    final notifSvc = ref.read(notificationServiceProvider);
    await notifSvc.showClockOutSummary(hoursStr, isOvertime);

    state = AsyncData(
      s.copyWith(shift: updated, expectedLogout: null),
    );
  }

  /// Retroactively edits clock-in and/or clock-out times.
  Future<void> editShiftTimes({
    DateTime? clockIn,
    DateTime? clockOut,
  }) async {
    final s = await future;
    final repo = ref.read(shiftRepositoryProvider);
    await repo.updateShiftTimes(
      s.shift.id,
      clockIn: clockIn,
      clockOut: clockOut,
    );

    // If clocked out too, recalculate actual hours.
    if (clockOut != null && s.shift.clockIn != null) {
      final ciTime = clockIn ?? s.shift.clockIn!;
      await repo.clockOut(
        s.shift.id,
        clockOut,
        targetWorkHours: s.profile.targetWorkHours,
        targetBreakHours: s.profile.targetBreakHours,
      );
      // Re-set clock-in in case it was overwritten.
      await repo.clockIn(s.shift.id, ciTime);
    }

    final updated = await repo.getOrCreateTodayShift();
    final expectedLogout = _calcExpectedLogout(updated, s.profile);

    state = AsyncData(
      s.copyWith(shift: updated, expectedLogout: expectedLogout),
    );
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  DateTime? _calcExpectedLogout(DailyShift shift, UserProfile profile) {
    if (shift.clockIn == null || shift.clockOut != null) return null;
    final totalHours = profile.targetWorkHours + profile.targetBreakHours;
    final totalMins = (totalHours * 60).round();
    return shift.clockIn!.add(Duration(minutes: totalMins));
  }

  static String _formatTime(DateTime? dt) {
    if (dt == null) return '--:--';
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  static String _formatHours(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return '${h}h ${m}m';
  }
}

// ── Convenience providers ─────────────────────────────────────────────────────

/// Watches today's shift live from the database (for reactive UI rebuilds).
@riverpod
Stream<DailyShift?> todayShiftStream(Ref ref) {
  final repo = ref.watch(shiftRepositoryProvider);
  return repo.watchTodayShift();
}
