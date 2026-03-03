import 'package:drift/drift.dart';

import 'timesheet_bucket.dart';

/// Drift table definition for [CategoryTags].
class CategoryTags extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Display name shown on chips in the timeline.
  TextColumn get tagName => text().unique()();

  /// FK to [TimesheetBuckets]. Null if unmapped.
  IntColumn get bucketId =>
      integer().nullable().references(TimesheetBuckets, #id)();
}
