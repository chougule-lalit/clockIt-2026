import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/app_database.dart';

part 'task_repository.g.dart';

@riverpod
TaskRepository taskRepository(Ref ref) {
  return TaskRepository(ref.read(appDatabaseProvider));
}

class TaskRepository {
  TaskRepository(this._db);
  final AppDatabase _db;

  // ── Queries ───────────────────────────────────────────────────────────────

  /// Live stream of all active (non-completed) tasks, oldest first.
  Stream<List<TaskItem>> watchActiveTasks() {
    return (_db.select(_db.taskItems)
          ..where((t) => t.isCompleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  /// Live stream of ALL tasks (active + completed), newest first.
  Stream<List<TaskItem>> watchAllTasks() {
    return (_db.select(_db.taskItems)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  /// Inserts a new task.
  Future<int> addTask(TaskItemsCompanion companion) =>
      _db.into(_db.taskItems).insert(companion);

  /// Updates an existing task row.
  Future<void> updateTask(TaskItemsCompanion companion) async {
    await (_db.update(_db.taskItems)
          ..where((t) => t.id.equals(companion.id.value)))
        .write(companion);
  }

  /// Marks a task complete.
  Future<void> completeTask(int id) async {
    await (_db.update(_db.taskItems)..where((t) => t.id.equals(id)))
        .write(const TaskItemsCompanion(isCompleted: Value(true)));
  }

  /// Marks a task active (undo complete).
  Future<void> uncompleteTask(int id) async {
    await (_db.update(_db.taskItems)..where((t) => t.id.equals(id)))
        .write(const TaskItemsCompanion(isCompleted: Value(false)));
  }

  /// Deletes a task permanently.
  Future<void> deleteTask(int id) async {
    await (_db.delete(_db.taskItems)..where((t) => t.id.equals(id))).go();
  }

  // ── Smart Rollover ────────────────────────────────────────────────────────

  /// Ensures every incomplete task's `createdAt` reflects today, so they
  /// always surface in an "active" list regardless of when they were created.
  /// Call once on app start (from TaskNotifier.build).
  Future<void> rolloverIncompleteTasks() async {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final stale = await (_db.select(_db.taskItems)
          ..where((t) =>
              t.isCompleted.equals(false) &
              t.createdAt.isSmallerThanValue(todayStart)))
        .get();

    for (final task in stale) {
      await (_db.update(_db.taskItems)..where((t) => t.id.equals(task.id)))
          .write(TaskItemsCompanion(createdAt: Value(DateTime.now())));
    }
  }
}
