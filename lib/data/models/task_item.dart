import 'package:drift/drift.dart';

import 'category_tag.dart';

/// Drift table definition for [TaskItems] (Task Bank).
class TaskItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Task title / description (e.g. "JIRA-4822 Code Review").
  TextColumn get description => text()();

  /// FK to [CategoryTags]. Null if not categorised.
  IntColumn get categoryId =>
      integer().nullable().references(CategoryTags, #id)();

  /// Whether the task has been completed.
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  /// When the task was created (used for daily rollover in Phase 4).
  DateTimeColumn get createdAt => dateTime()();
}
