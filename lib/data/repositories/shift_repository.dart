import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

part 'shift_repository.g.dart';

@riverpod
ShiftRepository shiftRepository(Ref ref) {
  return ShiftRepository(ref.read(appDatabaseProvider));
}

class ShiftRepository {
  ShiftRepository(this._db);
  final AppDatabase _db;

  // ── Default category tags ──────────────────────────────────────────────────

  static const _defaultCategories = [
    'Coding',
    'Meeting',
    'Break',
    'Support',
    'Review',
  ];

  /// Seeds default category tags if the table is empty.
  Future<void> ensureDefaultCategories() async {
    final existing = await _db.select(_db.categoryTags).get();
    if (existing.isNotEmpty) return;
    await _db.batch((batch) {
      batch.insertAll(
        _db.categoryTags,
        _defaultCategories
            .map((name) => CategoryTagsCompanion.insert(tagName: name))
            .toList(),
      );
    });
  }

  // ── Category tags ──────────────────────────────────────────────────────────

  Future<List<CategoryTag>> getAllCategories() =>
      _db.select(_db.categoryTags).get();

  Stream<List<CategoryTag>> watchAllCategories() =>
      _db.select(_db.categoryTags).watch();

  // ── Daily shifts ───────────────────────────────────────────────────────────

  /// Returns today's shift row, creating one if it does not exist yet.
  Future<DailyShift> getOrCreateTodayShift() async {
    final today = _todayDate();
    final existing = await (_db.select(_db.dailyShifts)
          ..where((t) => t.date.equals(today)))
        .getSingleOrNull();
    if (existing != null) return existing;

    final id = await _db.into(_db.dailyShifts).insert(
          DailyShiftsCompanion.insert(date: today),
        );
    return (_db.select(_db.dailyShifts)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  /// Watches today's shift for live updates.
  Stream<DailyShift?> watchTodayShift() {
    final today = _todayDate();
    return (_db.select(_db.dailyShifts)
          ..where((t) => t.date.equals(today)))
        .watchSingleOrNull();
  }

  /// Records clock-in time.
  Future<void> clockIn(int shiftId, DateTime time) async {
    await (_db.update(_db.dailyShifts)..where((t) => t.id.equals(shiftId)))
        .write(DailyShiftsCompanion(clockIn: Value(time)));
  }

  /// Records clock-out time and calculates actual hours and overtime delta.
  Future<void> clockOut(
    int shiftId,
    DateTime time, {
    required double targetWorkHours,
    required double targetBreakHours,
  }) async {
    // Get current row to read clockIn
    final shift = await (_db.select(_db.dailyShifts)
          ..where((t) => t.id.equals(shiftId)))
        .getSingle();
    if (shift.clockIn == null) return;

    final durationHours =
        time.difference(shift.clockIn!).inMinutes / 60.0;
    final targetTotal = targetWorkHours + targetBreakHours;
    final overtime = durationHours - targetTotal;

    await (_db.update(_db.dailyShifts)..where((t) => t.id.equals(shiftId)))
        .write(DailyShiftsCompanion(
      clockOut: Value(time),
      actualTotalHours: Value(durationHours),
      overtime: Value(overtime),
    ));
  }

  /// Retroactively edits clock-in and/or clock-out times.
  Future<void> updateShiftTimes(
    int shiftId, {
    DateTime? clockIn,
    DateTime? clockOut,
  }) async {
    await (_db.update(_db.dailyShifts)..where((t) => t.id.equals(shiftId)))
        .write(DailyShiftsCompanion(
      clockIn: clockIn != null ? Value(clockIn) : const Value.absent(),
      clockOut: clockOut != null ? Value(clockOut) : const Value.absent(),
    ));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Returns the start of today (midnight) as a DateTime.
  static DateTime _todayDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
