import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/task_repository.dart';

part 'task_notifier.g.dart';

// ── Live stream provider ──────────────────────────────────────────────────────

/// Watches all active (non-completed) tasks in real time.
@riverpod
Stream<List<TaskItem>> activeTasksStream(Ref ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.watchActiveTasks();
}

/// Watches ALL tasks (active + completed) in real time.
@riverpod
Stream<List<TaskItem>> allTasksStream(Ref ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.watchAllTasks();
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Manages task mutations and runs smart rollover on first build.
@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  Future<void> build() async {
    // Run smart rollover: stamp today's date on any stale incomplete tasks.
    final repo = ref.read(taskRepositoryProvider);
    await repo.rolloverIncompleteTasks();
  }

  // ── Add ──────────────────────────────────────────────────────────────────

  Future<void> addTask({
    required String description,
    int? categoryId,
  }) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.addTask(TaskItemsCompanion.insert(
      description: description,
      createdAt: DateTime.now(),
      categoryId: Value(categoryId),
    ));
  }

  // ── Complete / Uncomplete ─────────────────────────────────────────────────

  Future<void> completeTask(int id) =>
      ref.read(taskRepositoryProvider).completeTask(id);

  Future<void> uncompleteTask(int id) =>
      ref.read(taskRepositoryProvider).uncompleteTask(id);

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> deleteTask(int id) =>
      ref.read(taskRepositoryProvider).deleteTask(id);

  // ── Update ────────────────────────────────────────────────────────────────

  Future<void> updateTask(TaskItem task, {String? description, int? categoryId}) =>
      ref.read(taskRepositoryProvider).updateTask(TaskItemsCompanion(
            id: Value(task.id),
            description: description != null ? Value(description) : const Value.absent(),
            categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
          ));
}
