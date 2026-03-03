import 'package:drift/drift.dart';

/// Drift table definition for [DailyShift].
class DailyShifts extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// The calendar date for this shift (stored as ISO-8601 text).
  DateTimeColumn get date => dateTime()();

  /// When the user clocked in. Null if shift not yet started.
  DateTimeColumn get clockIn => dateTime().nullable()();

  /// When the user clocked out. Null if still in progress.
  DateTimeColumn get clockOut => dateTime().nullable()();

  /// Actual total hours worked. Computed on clock-out.
  RealColumn get actualTotalHours => real().nullable()();

  /// Positive = overtime, negative = early logout, null = in progress.
  RealColumn get overtime => real().nullable()();

  @override
  List<Set<Column<Object>>>? get uniqueColumns => [
        {date},
      ];
}
