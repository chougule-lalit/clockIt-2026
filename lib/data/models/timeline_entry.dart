import 'package:drift/drift.dart';

import 'category_tag.dart';
import 'daily_shift.dart';

/// Drift table definition for [TimelineEntries].
class TimelineEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK to the parent [DailyShifts].
  IntColumn get shiftId => integer().references(DailyShifts, #id)();

  /// Block start time.
  DateTimeColumn get startTime => dateTime()();

  /// Block end time.
  DateTimeColumn get endTime => dateTime()();

  /// FK to [CategoryTags]. Null if uncategorised.
  IntColumn get categoryId =>
      integer().nullable().references(CategoryTags, #id)();

  /// Free-text description (e.g. "JIRA-4822 Code Review").
  TextColumn get description => text().withDefault(const Constant(''))();
}
