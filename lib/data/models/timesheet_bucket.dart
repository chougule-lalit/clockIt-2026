import 'package:drift/drift.dart';

/// Drift table definition for [TimesheetBuckets].
class TimesheetBuckets extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// The official name matching the organisation's timesheet system.
  TextColumn get officialName => text().unique()();
}
