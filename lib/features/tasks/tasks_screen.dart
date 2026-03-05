import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/scratchpad_repository.dart';
import '../../data/repositories/shift_repository.dart';
import '../../data/repositories/timeline_entry_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../home/shift_notifier.dart';
import 'task_notifier.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Task Bank & Scratchpad Screen
// ─────────────────────────────────────────────────────────────────────────────

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Kick off rollover + initial data load.
    ref.read(taskNotifierProvider);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pill-style tab bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(32),
            ),
            padding: const EdgeInsets.all(4),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.accentPrimary,
                borderRadius: BorderRadius.circular(28),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              unselectedLabelStyle:
                  Theme.of(context).textTheme.labelLarge,
              tabs: const [
                Tab(text: 'Task Bank'),
                Tab(text: 'Scratchpad'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _TaskBankTab(),
              _ScratchpadTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Task Bank Tab
// ─────────────────────────────────────────────────────────────────────────────

class _TaskBankTab extends ConsumerStatefulWidget {
  const _TaskBankTab();

  @override
  ConsumerState<_TaskBankTab> createState() => _TaskBankTabState();
}

class _TaskBankTabState extends ConsumerState<_TaskBankTab> {
  final _quickAddController = TextEditingController();
  int? _quickAddCategoryId;
  bool _showCompleted = false;

  @override
  void dispose() {
    _quickAddController.dispose();
    super.dispose();
  }

  Future<void> _quickAdd() async {
    final text = _quickAddController.text.trim();
    if (text.isEmpty) return;
    await ref
        .read(taskNotifierProvider.notifier)
        .addTask(description: text, categoryId: _quickAddCategoryId);
    _quickAddController.clear();
    setState(() => _quickAddCategoryId = null);
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(
      _showCompleted ? allTasksStreamProvider : activeTasksStreamProvider,
    );

    return Column(
      children: [
        // ── Quick-add bar ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: _QuickAddBar(
            controller: _quickAddController,
            selectedCategoryId: _quickAddCategoryId,
            onCategoryChanged: (id) =>
                setState(() => _quickAddCategoryId = id),
            onSubmit: _quickAdd,
          ),
        ),

        // ── Show completed toggle ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            children: [
              Text(
                _showCompleted ? 'All tasks' : 'Active tasks',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _showCompleted = !_showCompleted),
                child: Text(
                  _showCompleted ? 'Hide completed' : 'Show completed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accentPrimary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.accentPrimary,
                      ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ── Task list ──────────────────────────────────────────────────────
        Expanded(
          child: tasksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (tasks) {
              if (tasks.isEmpty) {
                return _EmptyTaskBank(showCompleted: _showCompleted);
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
                itemCount: tasks.length,
                itemBuilder: (ctx, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _TaskCard(task: tasks[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick-add bar
// ─────────────────────────────────────────────────────────────────────────────

class _QuickAddBar extends ConsumerWidget {
  const _QuickAddBar({
    required this.controller,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategoryChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catsAsync = ref.watch(allCategoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Quick add task…',
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPlaceholder,
                        ),
                    filled: false,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  onSubmitted: (_) => onSubmit(),
                  textInputAction: TextInputAction.done,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_rounded,
                    color: AppColors.accentPrimary),
                onPressed: onSubmit,
                tooltip: 'Add task',
              ),
            ],
          ),
        ),
        // Category chip row for quick-add
        if (catsAsync.hasValue) ...[
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: catsAsync.value!.map((cat) {
                final isSelected = cat.id == selectedCategoryId;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(cat.tagName),
                    selected: isSelected,
                    onSelected: (_) =>
                        onCategoryChanged(isSelected ? null : cat.id),
                    selectedColor: AppColors.accentPrimary,
                    backgroundColor: AppColors.surface2,
                    labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.accentPrimary
                          : AppColors.divider,
                    ),
                    checkmarkColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Task Card
// ─────────────────────────────────────────────────────────────────────────────

class _TaskCard extends ConsumerWidget {
  const _TaskCard({required this.task});
  final TaskItem task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(taskNotifierProvider.notifier);
    final categories = ref.watch(allCategoriesProvider);

    final catName = categories.maybeWhen(
      data: (cats) => cats
          .where((c) => c.id == task.categoryId)
          .map((c) => c.tagName)
          .firstOrNull,
      orElse: () => null,
    );

    return Dismissible(
      key: ValueKey('task_${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: AppColors.danger),
      ),
      confirmDismiss: (_) async {
        await notifier.deleteTask(task.id);
        return false;
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: task.isCompleted
                ? AppColors.divider
                : AppColors.accentPrimary.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            GestureDetector(
              onTap: () => task.isCompleted
                  ? notifier.uncompleteTask(task.id)
                  : notifier.completeTask(task.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(top: 2, right: 12),
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? AppColors.success
                      : Colors.transparent,
                  border: Border.all(
                    color: task.isCompleted
                        ? AppColors.success
                        : AppColors.textPlaceholder,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white)
                    : null,
              ),
            ),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: task.isCompleted
                              ? AppColors.textPlaceholder
                              : AppColors.textPrimary,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: AppColors.textPlaceholder,
                        ),
                  ),
                  if (catName != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accentPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        catName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.accentPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Start Focus button (only for active tasks)
            if (!task.isCompleted) ...[
              const SizedBox(width: 8),
              _StartFocusButton(task: task),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// "▶ Start Focus" — push task straight to timeline
// ─────────────────────────────────────────────────────────────────────────────

class _StartFocusButton extends ConsumerWidget {
  const _StartFocusButton({required this.task});
  final TaskItem task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _pushToTimeline(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accentPrimary, Color(0xFF357ABD)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow_rounded,
                size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              'Focus',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pushToTimeline(BuildContext context, WidgetRef ref) async {
    final shiftAsync = ref.read(shiftNotifierProvider);
    final shiftId = shiftAsync.valueOrNull?.shift.id;

    if (shiftId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Clock in first before logging to timeline.'),
            backgroundColor: AppColors.surface2,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
      return;
    }

    // Show a time-range picker then push.
    if (context.mounted) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.surface2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) => _PushToTimelineSheet(task: task, shiftId: shiftId),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Push-to-Timeline Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _PushToTimelineSheet extends ConsumerStatefulWidget {
  const _PushToTimelineSheet({required this.task, required this.shiftId});
  final TaskItem task;
  final int shiftId;

  @override
  ConsumerState<_PushToTimelineSheet> createState() =>
      _PushToTimelineSheetState();
}

class _PushToTimelineSheetState extends ConsumerState<_PushToTimelineSheet> {
  late DateTime _startTime;
  late DateTime _endTime;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startTime = DateTime(now.year, now.month, now.day, now.hour, 0);
    _endTime = _startTime.add(const Duration(hours: 1));
  }

  String _fmt(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m ${dt.hour < 12 ? 'AM' : 'PM'}';
  }

  Future<void> _pick({required bool isStart}) async {
    final initial =
        TimeOfDay.fromDateTime(isStart ? _startTime : _endTime);
    final picked =
        await showTimePicker(context: context, initialTime: initial);
    if (picked == null || !mounted) return;
    final base = DateTime.now();
    final dt =
        DateTime(base.year, base.month, base.day, picked.hour, picked.minute);
    setState(() {
      if (isStart) {
        _startTime = dt;
        if (_endTime.isBefore(_startTime.add(const Duration(minutes: 1)))) {
          _endTime = _startTime.add(const Duration(hours: 1));
        }
      } else {
        _endTime = dt;
      }
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(timelineEntryRepositoryProvider);
      await repo.upsertEntry(TimelineEntriesCompanion.insert(
        shiftId: widget.shiftId,
        startTime: _startTime,
        endTime: _endTime,
        description: Value(widget.task.description),
        categoryId: Value(widget.task.categoryId),
      ));
      // Mark task complete.
      await ref.read(taskNotifierProvider.notifier).completeTask(widget.task.id);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log to Timeline',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          Text(
            widget.task.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _TimeRow(label: 'Start', time: _fmt(_startTime),
                  onTap: () => _pick(isStart: true))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.arrow_forward_rounded,
                    size: 18, color: AppColors.textPlaceholder),
              ),
              Expanded(child: _TimeRow(label: 'End', time: _fmt(_endTime),
                  onTap: () => _pick(isStart: false))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_rounded),
              label: _saving
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Add to Timeline'),
              onPressed: _saving ? null : _save,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({required this.label, required this.time, required this.onTap});
  final String label;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary, fontSize: 10)),
            const SizedBox(height: 2),
            Text(time,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyTaskBank extends StatelessWidget {
  const _EmptyTaskBank({required this.showCompleted});
  final bool showCompleted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.checklist_rounded,
              size: 52, color: AppColors.textPlaceholder),
          const SizedBox(height: 16),
          Text(
            showCompleted ? 'No tasks yet' : 'All caught up! 🎉',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            showCompleted
                ? 'Use the quick-add bar above to create tasks.'
                : 'All your tasks are done.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPlaceholder,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Scratchpad Tab
// ─────────────────────────────────────────────────────────────────────────────

class _ScratchpadTab extends ConsumerStatefulWidget {
  const _ScratchpadTab();

  @override
  ConsumerState<_ScratchpadTab> createState() => _ScratchpadTabState();
}

class _ScratchpadTabState extends ConsumerState<_ScratchpadTab> {
  final _controller = TextEditingController();
  Timer? _saveTimer;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(scratchpadRepositoryProvider);
    final text = await repo.load();
    if (mounted) {
      setState(() {
        _controller.text = text;
        _controller.selection = TextSelection.collapsed(offset: text.length);
        _loaded = true;
      });
    }
  }

  void _onChanged(String text) {
    _saveTimer?.cancel();
    // Debounce: auto-save 800ms after the user stops typing.
    _saveTimer = Timer(const Duration(milliseconds: 800), () {
      ref.read(scratchpadRepositoryProvider).save(text);
    });
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Converts the currently selected text into a Task Bank item.
  Future<void> _convertSelectionToTask() async {
    final selection = _controller.selection;
    if (!selection.isValid || selection.isCollapsed) return;
    final selected = _controller.text.substring(
      selection.start,
      selection.end,
    );
    if (selected.trim().isEmpty) return;

    await ref.read(taskNotifierProvider.notifier).addTask(
          description: selected.trim(),
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to Task Bank: "${selected.trim()}"'),
        backgroundColor: AppColors.surface2,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'OK',
          textColor: AppColors.accentPrimary,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.7,
                  color: AppColors.textPrimary,
                ),
            decoration: InputDecoration(
              hintText:
                  'Brain-dump anything here… select text to convert to a task.',
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPlaceholder,
                    height: 1.7,
                  ),
              filled: false,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),

        // Floating "Convert to Task" action button — visible when text is selected.
        Positioned(
          bottom: 16,
          right: 16,
          child: ListenableBuilder(
            listenable: _controller,
            builder: (ctx, _) {
              final hasSelection = _controller.selection.isValid &&
                  !_controller.selection.isCollapsed;
              return AnimatedOpacity(
                opacity: hasSelection ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: FloatingActionButton.extended(
                  onPressed: hasSelection ? _convertSelectionToTask : null,
                  backgroundColor: AppColors.accentSecondary,
                  foregroundColor: Colors.black87,
                  icon: const Icon(Icons.add_task_rounded, size: 18),
                  label: const Text('Convert to Task',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  heroTag: 'convert_to_task',
                ),
              );
            },
          ),
        ),

        // Auto-save indicator
        Positioned(
          top: 14,
          right: 20,
          child: Text(
            'auto-saved',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPlaceholder,
                  fontSize: 10,
                ),
          ),
        ),
      ],
    );
  }
}
