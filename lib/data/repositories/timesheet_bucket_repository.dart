import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

part 'timesheet_bucket_repository.g.dart';

@riverpod
TimesheetBucketRepository timesheetBucketRepository(Ref ref) {
  final db = ref.read(appDatabaseProvider);
  return TimesheetBucketRepository(db);
}

class TimesheetBucketRepository {
  TimesheetBucketRepository(this._db);
  final AppDatabase _db;

  Future<List<TimesheetBucket>> getAll() =>
      _db.select(_db.timesheetBuckets).get();

  Future<void> add(String name) async {
    await _db.into(_db.timesheetBuckets).insert(
          TimesheetBucketsCompanion.insert(officialName: name.trim()),
        );
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.timesheetBuckets)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}
