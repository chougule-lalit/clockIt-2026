import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

part 'timeline_entry_repository.g.dart';

@riverpod
TimelineEntryRepository timelineEntryRepository(Ref ref) {
  return TimelineEntryRepository(ref.read(appDatabaseProvider));
}

class TimelineEntryRepository {
  TimelineEntryRepository(this._db);
  final AppDatabase _db;

  /// Live stream of all timeline entries for a given shift, ordered by start time.
  Stream<List<TimelineEntry>> watchEntriesForShift(int shiftId) {
    return (_db.select(_db.timelineEntries)
          ..where((t) => t.shiftId.equals(shiftId))
          ..orderBy([(t) => OrderingTerm.asc(t.startTime)]))
        .watch();
  }

  /// Returns a one-time list of entries for a shift.
  Future<List<TimelineEntry>> getEntriesForShift(int shiftId) {
    return (_db.select(_db.timelineEntries)
          ..where((t) => t.shiftId.equals(shiftId))
          ..orderBy([(t) => OrderingTerm.asc(t.startTime)]))
        .get();
  }

  /// Inserts a new entry or updates an existing one by ID.
  Future<void> upsertEntry(TimelineEntriesCompanion entry) async {
    await _db.into(_db.timelineEntries).insertOnConflictUpdate(entry);
  }

  /// Deletes an entry by ID.
  Future<void> deleteEntry(int id) async {
    await (_db.delete(_db.timelineEntries)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}
