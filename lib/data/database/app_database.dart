import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/category_tag.dart';
import '../models/daily_shift.dart';
import '../models/task_item.dart';
import '../models/timeline_entry.dart';
import '../models/timesheet_bucket.dart';
import '../models/user_profile.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  UserProfiles,
  DailyShifts,
  TimesheetBuckets,
  CategoryTags,
  TaskItems,
  TimelineEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'clockit.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// ─────────────────────────────────────────────
// Riverpod provider for AppDatabase
// ─────────────────────────────────────────────

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
