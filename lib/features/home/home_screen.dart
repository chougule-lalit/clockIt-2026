import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/shift_repository.dart';
import '../../data/repositories/timeline_entry_repository.dart';
import 'shift_notifier.dart';

// ── Shell with bottom navigation ──────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const _labels = ['Home', 'Tasks', 'Timer', 'Analytics', 'Reports'];
  static const _icons = [
    Icons.home_rounded,
    Icons.checklist_rounded,
    Icons.timer_rounded,
    Icons.bar_chart_rounded,
    Icons.description_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClockIt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: 'Settings',
            onPressed: () => context.goNamed('settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _selectedIndex == 0
          ? const _HomeBody()
          : _ComingSoonBody(label: _labels[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface1,
        indicatorColor: AppColors.accentPrimary.withValues(alpha: 0.15),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: _labels.asMap().entries.map((e) {
          return NavigationDestination(
            icon: Icon(_icons[e.key], color: AppColors.textSecondary),
            selectedIcon: Icon(_icons[e.key], color: AppColors.accentPrimary),
            label: e.value,
          );
        }).toList(),
      ),
    );
  }
}

// ── Home tab body ─────────────────────────────────────────────────────────────

class _HomeBody extends ConsumerWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftAsync = ref.watch(shiftNotifierProvider);

    return shiftAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (state) => _HomeContent(state: state),
    );
  }
}

// ── Main scrollable content ───────────────────────────────────────────────────

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.state});
  final ShiftState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _SmartClockCard(state: state),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Text(
              "Today's Timeline",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        _TimelineSliver(shiftId: state.shift.id, state: state),
        // Bottom padding for FAB
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

// ── Smart Clock Card ──────────────────────────────────────────────────────────

class _SmartClockCard extends ConsumerWidget {
  const _SmartClockCard({required this.state});
  final ShiftState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(shiftNotifierProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Label
          Text(
            'SMART CLOCK',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 20),

          // Pill toggle
          _ClockPillToggle(
            isClockedIn: state.isClockedIn,
            isClockedOut: state.isClockedOut,
            onClockIn: () => notifier.clockIn(),
            onClockOut: () => notifier.clockOut(),
          ),

          // Expected logout
          if (state.isClockedIn && state.expectedLogout != null) ...[
            const SizedBox(height: 14),
            Text(
              'Expected Logout: ${_formatTime(state.expectedLogout!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.accentSecondary,
                  ),
            ),
          ],

          // Overtime badge on clock-out
          if (state.isClockedOut && state.overtimeDelta != null) ...[
            const SizedBox(height: 14),
            _OvertimeBadge(delta: state.overtimeDelta!),
          ],

          // Clocked-in timestamp
          if (state.isClockedIn && state.shift.clockIn != null) ...[
            const SizedBox(height: 8),
            Text(
              'Clocked in at ${_formatTime(state.shift.clockIn!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPlaceholder,
                    fontSize: 11,
                  ),
            ),
          ],

          // Edit shift times link
          const SizedBox(height: 12),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => _showEditShiftDialog(context, ref, state),
            child: Text(
              'Edit Shift Times',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPlaceholder,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.textPlaceholder,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  Future<void> _showEditShiftDialog(
    BuildContext context,
    WidgetRef ref,
    ShiftState state,
  ) async {
    final notifier = ref.read(shiftNotifierProvider.notifier);
    DateTime? newClockIn = state.shift.clockIn;
    DateTime? newClockOut = state.shift.clockOut;
    final now = DateTime.now();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface2,
        title: const Text('Edit Shift Times'),
        content: _EditShiftDialogContent(
          initialClockIn: newClockIn,
          initialClockOut: newClockOut,
          onClockInChanged: (dt) => newClockIn = dt,
          onClockOutChanged: (dt) => newClockOut = dt,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await notifier.editShiftTimes(
                clockIn: newClockIn,
                clockOut: newClockOut,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ── Clock Pill Toggle ─────────────────────────────────────────────────────────

class _ClockPillToggle extends StatelessWidget {
  const _ClockPillToggle({
    required this.isClockedIn,
    required this.isClockedOut,
    required this.onClockIn,
    required this.onClockOut,
  });

  final bool isClockedIn;
  final bool isClockedOut;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PillSide(
            label: 'Clock In',
            isActive: !isClockedIn && !isClockedOut,
            isEnabled: !isClockedIn && !isClockedOut,
            activeColor: AppColors.accentPrimary,
            onTap: onClockIn,
          ),
          _PillSide(
            label: 'Clock Out',
            isActive: isClockedIn,
            isEnabled: isClockedIn,
            activeColor: AppColors.danger,
            onTap: onClockOut,
          ),
        ],
      ),
    );
  }
}

class _PillSide extends StatelessWidget {
  const _PillSide({
    required this.label,
    required this.isActive,
    required this.isEnabled,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final bool isEnabled;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isActive
                    ? Colors.white
                    : isEnabled
                        ? AppColors.textSecondary
                        : AppColors.textPlaceholder,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

// ── Overtime Badge ─────────────────────────────────────────────────────────────

class _OvertimeBadge extends StatelessWidget {
  const _OvertimeBadge({required this.delta});
  final double delta;

  @override
  Widget build(BuildContext context) {
    final isOvertime = delta > 0;
    final absDelta = delta.abs();
    final h = absDelta.floor();
    final m = ((absDelta - h) * 60).round();
    final label = isOvertime
        ? '+${h}h ${m}m overtime'
        : '${h}h ${m}m early';
    final color =
        isOvertime ? AppColors.warning : AppColors.accentSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
      ),
    );
  }
}

// ── Edit Shift Dialog Content ─────────────────────────────────────────────────

class _EditShiftDialogContent extends StatefulWidget {
  const _EditShiftDialogContent({
    required this.initialClockIn,
    required this.initialClockOut,
    required this.onClockInChanged,
    required this.onClockOutChanged,
  });

  final DateTime? initialClockIn;
  final DateTime? initialClockOut;
  final ValueChanged<DateTime?> onClockInChanged;
  final ValueChanged<DateTime?> onClockOutChanged;

  @override
  State<_EditShiftDialogContent> createState() =>
      _EditShiftDialogContentState();
}

class _EditShiftDialogContentState extends State<_EditShiftDialogContent> {
  TimeOfDay? _clockInTod;
  TimeOfDay? _clockOutTod;

  @override
  void initState() {
    super.initState();
    if (widget.initialClockIn != null) {
      _clockInTod = TimeOfDay.fromDateTime(widget.initialClockIn!);
    }
    if (widget.initialClockOut != null) {
      _clockOutTod = TimeOfDay.fromDateTime(widget.initialClockOut!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TimePicker(
          label: 'Clock In',
          selected: _clockInTod,
          onPick: (tod) {
            setState(() => _clockInTod = tod);
            final now = DateTime.now();
            widget.onClockInChanged(
              DateTime(now.year, now.month, now.day, tod.hour, tod.minute),
            );
          },
        ),
        const SizedBox(height: 12),
        _TimePicker(
          label: 'Clock Out',
          selected: _clockOutTod,
          onPick: (tod) {
            setState(() => _clockOutTod = tod);
            final now = DateTime.now();
            widget.onClockOutChanged(
              DateTime(now.year, now.month, now.day, tod.hour, tod.minute),
            );
          },
        ),
      ],
    );
  }
}

class _TimePicker extends StatelessWidget {
  const _TimePicker({
    required this.label,
    required this.selected,
    required this.onPick,
  });

  final String label;
  final TimeOfDay? selected;
  final ValueChanged<TimeOfDay> onPick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: selected ?? TimeOfDay.now(),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary)),
            Text(
              selected != null ? selected!.format(context) : 'Tap to set',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected != null
                        ? AppColors.textPrimary
                        : AppColors.textPlaceholder,
                    fontWeight:
                        selected != null ? FontWeight.w500 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Timeline Sliver ───────────────────────────────────────────────────────────

class _TimelineSliver extends ConsumerWidget {
  const _TimelineSliver({required this.shiftId, required this.state});

  final int shiftId;
  final ShiftState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(
      StreamProvider((r) =>
          r.read(timelineEntryRepositoryProvider).watchEntriesForShift(shiftId)),
    );

    final profile = state.profile;
    final startHour = profile.defaultStartHour;
    final endHour = _endHour(state);

    return entriesAsync.when(
      loading: () => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
      data: (entries) {
        final slots = List.generate(
          endHour - startHour + 1,
          (i) => startHour + i,
        );

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final hour = slots[i];
                final slotStart = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  hour,
                );
                final slotEnd = slotStart.add(const Duration(hours: 1));

                // Find any entry overlapping this slot.
                final entry = entries.where((e) {
                  return e.startTime.hour == hour ||
                      (e.startTime.isBefore(slotEnd) &&
                          e.endTime.isAfter(slotStart));
                }).firstOrNull;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _TimelineSlot(
                    hour: hour,
                    shiftId: shiftId,
                    existingEntry: entry,
                    slotStart: slotStart,
                    slotEnd: slotEnd,
                  ),
                );
              },
              childCount: slots.length,
            ),
          ),
        );
      },
    );
  }

  int _endHour(ShiftState state) {
    final now = DateTime.now();
    final clockOut = state.shift.clockOut;
    if (clockOut != null) return clockOut.hour + 1;
    final expected = state.expectedLogout;
    if (expected != null) return expected.hour + 1;
    final rawEnd =
        now.hour + 2; // two hours beyond current if nothing set
    return rawEnd.clamp(state.profile.defaultStartHour + 8, 23);
  }
}

// ── Single Timeline Slot ──────────────────────────────────────────────────────

class _TimelineSlot extends ConsumerStatefulWidget {
  const _TimelineSlot({
    required this.hour,
    required this.shiftId,
    required this.existingEntry,
    required this.slotStart,
    required this.slotEnd,
  });

  final int hour;
  final int shiftId;
  final TimelineEntry? existingEntry;
  final DateTime slotStart;
  final DateTime slotEnd;

  @override
  ConsumerState<_TimelineSlot> createState() => _TimelineSlotState();
}

class _TimelineSlotState extends ConsumerState<_TimelineSlot> {
  bool _expanded = false;
  final _descController = TextEditingController();
  CategoryTag? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.existingEntry != null) {
      _descController.text = widget.existingEntry!.description;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  String get _hourLabel {
    final h = widget.hour % 12 == 0 ? 12 : widget.hour % 12;
    final period = widget.hour < 12 ? 'AM' : 'PM';
    return '$h:00\n$period';
  }

  @override
  Widget build(BuildContext context) {
    final hasEntry = widget.existingEntry != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time label column
        SizedBox(
          width: 44,
          child: Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              _hourLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPlaceholder,
                    fontSize: 10,
                    height: 1.4,
                  ),
            ),
          ),
        ),
        // Timeline track line
        Padding(
          padding: const EdgeInsets.only(top: 0, right: 10),
          child: Column(
            children: [
              Container(
                width: 2,
                height: 16,
                color: AppColors.divider,
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: hasEntry
                      ? AppColors.accentPrimary
                      : AppColors.divider,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: AppColors.divider,
              ),
            ],
          ),
        ),
        // Slot card
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: _expanded
                    ? AppColors.surface2
                    : hasEntry
                        ? AppColors.surface1
                        : AppColors.surface1,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _expanded
                      ? AppColors.accentPrimary.withValues(alpha: 0.5)
                      : hasEntry
                          ? AppColors.accentPrimary.withValues(alpha: 0.2)
                          : AppColors.divider,
                ),
              ),
              child: _expanded
                  ? _ExpandedSlotContent(
                      shiftId: widget.shiftId,
                      existingEntry: widget.existingEntry,
                      slotStart: widget.slotStart,
                      slotEnd: widget.slotEnd,
                      onSaved: () =>
                          setState(() => _expanded = false),
                      onCancelled: () =>
                          setState(() => _expanded = false),
                    )
                  : _CollapsedSlotContent(entry: widget.existingEntry),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Collapsed slot preview ────────────────────────────────────────────────────

class _CollapsedSlotContent extends ConsumerWidget {
  const _CollapsedSlotContent({required this.entry});
  final TimelineEntry? entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entry == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Text(
          '+ Tap to log a task',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPlaceholder,
              ),
        ),
      );
    }

    // Load category name
    final categories = ref.watch(
      StreamProvider((r) =>
          r.read(shiftRepositoryProvider).watchAllCategories()),
    );

    final catName = categories.maybeWhen(
      data: (cats) => cats
          .where((c) => c.id == entry!.categoryId)
          .map((c) => c.tagName)
          .firstOrNull,
      orElse: () => null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          if (catName != null) ...[
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accentPrimary.withValues(alpha: 0.2),
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
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              entry!.description.isEmpty ? 'No description' : entry!.description,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Expanded slot form ────────────────────────────────────────────────────────

class _ExpandedSlotContent extends ConsumerStatefulWidget {
  const _ExpandedSlotContent({
    required this.shiftId,
    required this.existingEntry,
    required this.slotStart,
    required this.slotEnd,
    required this.onSaved,
    required this.onCancelled,
  });

  final int shiftId;
  final TimelineEntry? existingEntry;
  final DateTime slotStart;
  final DateTime slotEnd;
  final VoidCallback onSaved;
  final VoidCallback onCancelled;

  @override
  ConsumerState<_ExpandedSlotContent> createState() =>
      _ExpandedSlotContentState();
}

class _ExpandedSlotContentState extends ConsumerState<_ExpandedSlotContent> {
  late final TextEditingController _descController;
  int? _selectedCategoryId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _descController =
        TextEditingController(text: widget.existingEntry?.description ?? '');
    _selectedCategoryId = widget.existingEntry?.categoryId;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(timelineEntryRepositoryProvider);
      final entry = TimelineEntriesCompanion.insert(
        shiftId: widget.shiftId,
        startTime: widget.slotStart,
        endTime: widget.slotEnd,
        description: Value(_descController.text.trim()),
        categoryId: Value(_selectedCategoryId),
      );
      await repo.upsertEntry(entry);
      if (mounted) widget.onSaved();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final catsAsync = ref.watch(
      StreamProvider((r) =>
          r.read(shiftRepositoryProvider).watchAllCategories()),
    );

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description field
          TextField(
            controller: _descController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter task details (e.g. JIRA-123 Code Review)…',
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPlaceholder,
                  ),
              filled: false,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),

          // Category chips
          catsAsync.when(
            loading: () =>
                const SizedBox(height: 32, child: LinearProgressIndicator()),
            error: (_, __) => const SizedBox(),
            data: (cats) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: cats.map((cat) {
                  final isSelected = cat.id == _selectedCategoryId;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat.tagName),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategoryId =
                              isSelected ? null : cat.id;
                        });
                      },
                      selectedColor: AppColors.accentPrimary,
                      backgroundColor: AppColors.surface2,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 12,
                          ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.accentPrimary
                            : AppColors.divider,
                      ),
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Save / Cancel
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancelled,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 36),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 0),
                ),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Coming-soon placeholder ───────────────────────────────────────────────────

class _ComingSoonBody extends StatelessWidget {
  const _ComingSoonBody({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction_rounded,
                size: 48, color: AppColors.textPlaceholder),
            const SizedBox(height: 16),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Coming in a future phase.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPlaceholder,
                  ),
            ),
          ],
        ),
      );
}
