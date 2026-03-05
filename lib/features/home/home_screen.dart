import 'package:drift/drift.dart' hide Column;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/shift_repository.dart';
import '../../data/repositories/timeline_entry_repository.dart';
import 'shift_notifier.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

String _fmt(DateTime dt) {
  final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m ${dt.hour < 12 ? 'AM' : 'PM'}';
}

String _fmtTod(TimeOfDay t, BuildContext ctx) => t.format(ctx);

/// Rounds a DateTime to the nearest N minutes.
DateTime _roundToNearest(DateTime dt, int minutes) {
  final rem = dt.minute % minutes;
  return rem < minutes ~/ 2
      ? dt.subtract(Duration(minutes: rem))
      : dt.add(Duration(minutes: minutes - rem));
}

// ─────────────────────────────────────────────────────────────────────────────
// Shell – Bottom Navigation
// ─────────────────────────────────────────────────────────────────────────────

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
    final shiftAsync = ref.watch(shiftNotifierProvider);
    final shiftId = shiftAsync.valueOrNull?.shift.id;

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
      floatingActionButton: _selectedIndex == 0 && shiftId != null
          ? FloatingActionButton(
              backgroundColor: AppColors.accentPrimary,
              foregroundColor: Colors.white,
              tooltip: 'Add off-schedule block',
              onPressed: () => _showAddBlockSheet(context, shiftId),
              child: const Icon(Icons.add_rounded),
            )
          : null,
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

  Future<void> _showAddBlockSheet(BuildContext context, int shiftId) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AddBlockBottomSheet(shiftId: shiftId),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Home tab body
// ─────────────────────────────────────────────────────────────────────────────

class _HomeBody extends ConsumerWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftAsync = ref.watch(shiftNotifierProvider);
    return shiftAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (state) => _HomeContent(state: state),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main scrollable content
// ─────────────────────────────────────────────────────────────────────────────

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
          child: _TimelineHeader(state: state),
        ),
        _TimelineSliver(shiftId: state.shift.id, state: state),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timeline header with day summary pill
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineHeader extends ConsumerWidget {
  const _TimelineHeader({required this.state});
  final ShiftState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(
      StreamProvider((r) => r
          .read(timelineEntryRepositoryProvider)
          .watchEntriesForShift(state.shift.id)),
    );

    final targetHours = state.profile.targetWorkHours;

    final loggedMinutes = entriesAsync.maybeWhen(
      data: (entries) => entries.fold<int>(
        0,
        (sum, e) => sum + e.endTime.difference(e.startTime).inMinutes,
      ),
      orElse: () => 0,
    );

    final loggedH = loggedMinutes ~/ 60;
    final loggedM = loggedMinutes % 60;
    final progress = (loggedMinutes / (targetHours * 60)).clamp(0.0, 1.0);
    final isComplete = loggedMinutes >= (targetHours * 60);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Timeline",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              // Summary pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isComplete
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.accentPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${loggedH}h ${loggedM}m / ${targetHours.toStringAsFixed(0)}h',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isComplete
                            ? AppColors.success
                            : AppColors.accentPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete ? AppColors.success : AppColors.accentPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Smart Clock Card
// ─────────────────────────────────────────────────────────────────────────────

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
          Text(
            'SMART CLOCK',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 20),
          _ClockPillToggle(
            isClockedIn: state.isClockedIn,
            isClockedOut: state.isClockedOut,
            onClockIn: () => notifier.clockIn(),
            onClockOut: () => notifier.clockOut(),
          ),
          if (state.isClockedIn && state.expectedLogout != null) ...[
            const SizedBox(height: 14),
            Text(
              'Expected Logout: ${_fmt(state.expectedLogout!)}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.accentSecondary),
            ),
          ],
          if (state.isClockedOut && state.overtimeDelta != null) ...[
            const SizedBox(height: 14),
            _OvertimeBadge(delta: state.overtimeDelta!),
          ],
          if (state.isClockedIn && state.shift.clockIn != null) ...[
            const SizedBox(height: 8),
            Text(
              'Clocked in at ${_fmt(state.shift.clockIn!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPlaceholder,
                    fontSize: 11,
                  ),
            ),
          ],
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

  Future<void> _showEditShiftDialog(
    BuildContext context,
    WidgetRef ref,
    ShiftState state,
  ) async {
    final notifier = ref.read(shiftNotifierProvider.notifier);
    DateTime? newClockIn = state.shift.clockIn;
    DateTime? newClockOut = state.shift.clockOut;

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
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
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

// ─────────────────────────────────────────────────────────────────────────────
// Clock Pill Toggle
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// Overtime Badge
// ─────────────────────────────────────────────────────────────────────────────

class _OvertimeBadge extends StatelessWidget {
  const _OvertimeBadge({required this.delta});
  final double delta;

  @override
  Widget build(BuildContext context) {
    final isOvertime = delta > 0;
    final abs = delta.abs();
    final h = abs.floor();
    final m = ((abs - h) * 60).round();
    final label = isOvertime ? '+${h}h ${m}m overtime' : '${h}h ${m}m early';
    final color = isOvertime ? AppColors.warning : AppColors.accentSecondary;
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

// ─────────────────────────────────────────────────────────────────────────────
// Edit Shift Times dialog
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// Reusable time picker row
// ─────────────────────────────────────────────────────────────────────────────

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
              selected != null ? _fmtTod(selected!, context) : 'Tap to set',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected != null
                        ? AppColors.textPrimary
                        : AppColors.textPlaceholder,
                    fontWeight: selected != null
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timeline Sliver — builds hourly + off-schedule slots
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineSliver extends ConsumerWidget {
  const _TimelineSliver({required this.shiftId, required this.state});

  final int shiftId;
  final ShiftState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(
      StreamProvider((r) => r
          .read(timelineEntryRepositoryProvider)
          .watchEntriesForShift(shiftId)),
    );

    final profile = state.profile;
    final startHour = profile.defaultStartHour;
    final endHour = _calcEndHour(state);

    return entriesAsync.when(
      loading: () => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
      data: (entries) {
        final today = DateTime.now();

        // Build list of hourly slots.
        final hourSlots = List.generate(
          (endHour - startHour + 1).clamp(0, 24),
          (i) => startHour + i,
        );

        // Find off-schedule entries (those that don't start on an exact hour).
        final offSchedule = entries.where((e) {
          return e.startTime.minute != 0 &&
              !hourSlots.any((h) => e.startTime.hour == h);
        }).toList();

        // Build a merged, chronologically sorted list of items.
        // Each item is either an int (hour slot) or a TimelineEntry (off-sched).
        final items = <dynamic>[...hourSlots];
        for (final e in offSchedule) {
          // Insert at correct position.
          final insertIdx = items.indexWhere((item) {
            if (item is int) return item > e.startTime.hour;
            if (item is TimelineEntry) {
              return item.startTime.isAfter(e.startTime);
            }
            return false;
          });
          if (insertIdx == -1) {
            items.add(e);
          } else {
            items.insert(insertIdx, e);
          }
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final item = items[i];

                if (item is int) {
                  // Standard hourly slot.
                  final hour = item;
                  final slotStart = DateTime(
                      today.year, today.month, today.day, hour, 0);
                  final slotEnd = slotStart.add(const Duration(hours: 1));

                  final entry = entries.where((e) {
                    return e.startTime.hour == hour && e.startTime.minute == 0;
                  }).firstOrNull;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _TimelineSlot(
                      hour: hour,
                      shiftId: shiftId,
                      existingEntry: entry,
                      slotStart: slotStart,
                      slotEnd: slotEnd,
                      isOffSchedule: false,
                    ),
                  );
                } else if (item is TimelineEntry) {
                  // Off-schedule entry.
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _TimelineSlot(
                      hour: item.startTime.hour,
                      shiftId: shiftId,
                      existingEntry: item,
                      slotStart: item.startTime,
                      slotEnd: item.endTime,
                      isOffSchedule: true,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              childCount: items.length,
            ),
          ),
        );
      },
    );
  }

  int _calcEndHour(ShiftState state) {
    final now = DateTime.now();
    final clockOut = state.shift.clockOut;
    if (clockOut != null) return clockOut.hour + 1;
    final expected = state.expectedLogout;
    if (expected != null) return expected.hour + 1;
    final raw = now.hour + 2;
    return raw.clamp(state.profile.defaultStartHour + 8, 23);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single Timeline Slot
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineSlot extends ConsumerStatefulWidget {
  const _TimelineSlot({
    required this.hour,
    required this.shiftId,
    required this.existingEntry,
    required this.slotStart,
    required this.slotEnd,
    required this.isOffSchedule,
  });

  final int hour;
  final int shiftId;
  final TimelineEntry? existingEntry;
  final DateTime slotStart;
  final DateTime slotEnd;
  final bool isOffSchedule;

  @override
  ConsumerState<_TimelineSlot> createState() => _TimelineSlotState();
}

class _TimelineSlotState extends ConsumerState<_TimelineSlot> {
  bool _expanded = false;

  String get _timeLabel {
    if (widget.isOffSchedule) {
      // Show "10:15 → 11:45" for off-schedule
      final startH = widget.slotStart.hour % 12 == 0
          ? 12
          : widget.slotStart.hour % 12;
      final startM =
          widget.slotStart.minute.toString().padLeft(2, '0');
      final endH =
          widget.slotEnd.hour % 12 == 0 ? 12 : widget.slotEnd.hour % 12;
      final endM = widget.slotEnd.minute.toString().padLeft(2, '0');
      return '$startH:$startM\n→$endH:$endM';
    }
    final h = widget.hour % 12 == 0 ? 12 : widget.hour % 12;
    final period = widget.hour < 12 ? 'AM' : 'PM';
    return '$h:00\n$period';
  }

  Future<void> _deleteEntry() async {
    final entry = widget.existingEntry;
    if (entry == null) return;
    await ref.read(timelineEntryRepositoryProvider).deleteEntry(entry.id);
  }

  @override
  Widget build(BuildContext context) {
    final hasEntry = widget.existingEntry != null;

    final card = GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: _expanded ? AppColors.surface2 : AppColors.surface1,
          borderRadius: BorderRadius.circular(12),
          border: _expanded
              ? Border.all(
                  color: AppColors.accentPrimary.withValues(alpha: 0.6),
                  width: 1.5,
                )
              : hasEntry
                  ? Border(
                      left: const BorderSide(
                        color: AppColors.accentPrimary,
                        width: 3,
                      ),
                      top: BorderSide(
                          color: AppColors.accentPrimary
                              .withValues(alpha: 0.15)),
                      right: BorderSide(
                          color: AppColors.accentPrimary
                              .withValues(alpha: 0.15)),
                      bottom: BorderSide(
                          color: AppColors.accentPrimary
                              .withValues(alpha: 0.15)),
                    )
                  : Border.all(color: AppColors.divider),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _expanded
              ? _ExpandedSlotContent(
                  shiftId: widget.shiftId,
                  existingEntry: widget.existingEntry,
                  slotStart: widget.slotStart,
                  slotEnd: widget.slotEnd,
                  onSaved: () => setState(() => _expanded = false),
                  onCancelled: () => setState(() => _expanded = false),
                  onDeleted: hasEntry ? _deleteEntry : null,
                )
              : _CollapsedSlotContent(
                  entry: widget.existingEntry,
                  isOffSchedule: widget.isOffSchedule,
                ),
        ),
      ),
    );

    // Wrap filled slots with swipe-to-delete.
    if (hasEntry && !_expanded) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SlotTimeLabel(label: _timeLabel),
          _SlotTrackDot(filled: true),
          Expanded(
            child: Dismissible(
              key: ValueKey('slot_${widget.existingEntry!.id}'),
              direction: DismissDirection.endToStart,
              background: _SwipeDeleteBackground(),
              confirmDismiss: (_) async {
                await _deleteEntry();
                return false; // Drift stream handles UI removal.
              },
              child: card,
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SlotTimeLabel(label: _timeLabel),
        _SlotTrackDot(filled: hasEntry),
        Expanded(child: card),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timeline track sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SlotTimeLabel extends StatelessWidget {
  const _SlotTimeLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPlaceholder,
                fontSize: 10,
                height: 1.4,
              ),
        ),
      ),
    );
  }
}

class _SlotTrackDot extends StatelessWidget {
  const _SlotTrackDot({required this.filled});
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(width: 2, height: 16, color: AppColors.divider),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: filled ? AppColors.accentPrimary : AppColors.divider,
              shape: BoxShape.circle,
            ),
          ),
          Container(width: 2, height: 40, color: AppColors.divider),
        ],
      ),
    );
  }
}

class _SwipeDeleteBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete_rounded, color: AppColors.danger),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Collapsed slot preview
// ─────────────────────────────────────────────────────────────────────────────

class _CollapsedSlotContent extends ConsumerWidget {
  const _CollapsedSlotContent({
    required this.entry,
    required this.isOffSchedule,
  });
  final TimelineEntry? entry;
  final bool isOffSchedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entry == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Text(
          '+ Tap to log a task',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textPlaceholder),
        ),
      );
    }

    final categories = ref.watch(
      StreamProvider(
          (r) => r.read(shiftRepositoryProvider).watchAllCategories()),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
              entry!.description.isEmpty
                  ? 'No description'
                  : entry!.description,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Edit hint
          const Icon(Icons.edit_rounded,
              size: 14, color: AppColors.textPlaceholder),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Expanded slot form (create + edit + delete)
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandedSlotContent extends ConsumerStatefulWidget {
  const _ExpandedSlotContent({
    required this.shiftId,
    required this.existingEntry,
    required this.slotStart,
    required this.slotEnd,
    required this.onSaved,
    required this.onCancelled,
    required this.onDeleted,
  });

  final int shiftId;
  final TimelineEntry? existingEntry;
  final DateTime slotStart;
  final DateTime slotEnd;
  final VoidCallback onSaved;
  final VoidCallback onCancelled;
  final Future<void> Function()? onDeleted;

  @override
  ConsumerState<_ExpandedSlotContent> createState() =>
      _ExpandedSlotContentState();
}

class _ExpandedSlotContentState extends ConsumerState<_ExpandedSlotContent> {
  late final TextEditingController _descController;
  int? _selectedCategoryId;
  bool _saving = false;
  bool _deleting = false;

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
      final companion = TimelineEntriesCompanion(
        id: widget.existingEntry != null
            ? Value(widget.existingEntry!.id)
            : const Value.absent(),
        shiftId: Value(widget.shiftId),
        startTime: Value(widget.slotStart),
        endTime: Value(widget.slotEnd),
        description: Value(_descController.text.trim()),
        categoryId: Value(_selectedCategoryId),
      );
      await repo.upsertEntry(companion);
      if (mounted) widget.onSaved();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    if (_deleting || widget.onDeleted == null) return;
    setState(() => _deleting = true);
    try {
      await widget.onDeleted!();
      if (mounted) widget.onCancelled();
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final catsAsync = ref.watch(
      StreamProvider(
          (r) => r.read(shiftRepositoryProvider).watchAllCategories()),
    );

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: title + delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.existingEntry != null ? 'Edit entry' : 'Log task',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (widget.onDeleted != null)
                _deleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : GestureDetector(
                        onTap: _delete,
                        child: const Icon(
                          Icons.delete_rounded,
                          size: 18,
                          color: AppColors.danger,
                        ),
                      ),
            ],
          ),
          const SizedBox(height: 10),

          // Description
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
                      onSelected: (_) => setState(() {
                        _selectedCategoryId = isSelected ? null : cat.id;
                      }),
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
                          borderRadius: BorderRadius.circular(8)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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

// ─────────────────────────────────────────────────────────────────────────────
// Add Off-Schedule Block — Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _AddBlockBottomSheet extends ConsumerStatefulWidget {
  const _AddBlockBottomSheet({required this.shiftId});
  final int shiftId;

  @override
  ConsumerState<_AddBlockBottomSheet> createState() =>
      _AddBlockBottomSheetState();
}

class _AddBlockBottomSheetState extends ConsumerState<_AddBlockBottomSheet> {
  late DateTime _startTime;
  late DateTime _endTime;
  late final TextEditingController _descController;
  int? _selectedCategoryId;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final now = _roundToNearest(DateTime.now(), 15);
    _startTime = now;
    _endTime = now.add(const Duration(hours: 1));
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_endTime.isBefore(_startTime) ||
        _endTime.isAtSameMomentAs(_startTime)) {
      setState(() => _error = 'End time must be after start time.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final repo = ref.read(timelineEntryRepositoryProvider);
      await repo.upsertEntry(TimelineEntriesCompanion.insert(
        shiftId: widget.shiftId,
        startTime: _startTime,
        endTime: _endTime,
        description: Value(_descController.text.trim()),
        categoryId: Value(_selectedCategoryId),
      ));
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = TimeOfDay.fromDateTime(isStart ? _startTime : _endTime);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null || !mounted) return;
    final base = DateTime.now();
    final dt = DateTime(base.year, base.month, base.day, picked.hour, picked.minute);
    setState(() {
      if (isStart) {
        _startTime = dt;
        if (_endTime.isBefore(_startTime.add(const Duration(minutes: 1)))) {
          _endTime = _startTime.add(const Duration(hours: 1));
        }
      } else {
        _endTime = dt;
      }
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final catsAsync = ref.watch(
      StreamProvider(
          (r) => r.read(shiftRepositoryProvider).watchAllCategories()),
    );

    final durationMin = _endTime.difference(_startTime).inMinutes;
    final durationStr = durationMin > 0
        ? '${durationMin ~/ 60}h ${durationMin % 60}m'
        : '--';

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add Block',
                  style: Theme.of(context).textTheme.titleSmall),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  durationStr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accentPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Time range row
          Row(
            children: [
              Expanded(
                child: _TimePicker(
                  label: 'Start',
                  selected: TimeOfDay.fromDateTime(_startTime),
                  onPick: (_) => _pickTime(isStart: true),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.arrow_forward_rounded,
                    color: AppColors.textPlaceholder, size: 18),
              ),
              Expanded(
                child: _TimePicker(
                  label: 'End',
                  selected: TimeOfDay.fromDateTime(_endTime),
                  onPick: (_) => _pickTime(isStart: false),
                ),
              ),
            ],
          ),

          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.danger)),
          ],

          const SizedBox(height: 16),

          // Description
          TextField(
            controller: _descController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Task description…',
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPlaceholder,
                  ),
            ),
          ),
          const SizedBox(height: 16),

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
                      onSelected: (_) => setState(() {
                        _selectedCategoryId = isSelected ? null : cat.id;
                      }),
                      selectedColor: AppColors.accentPrimary,
                      backgroundColor: AppColors.surface1,
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
                          borderRadius: BorderRadius.circular(8)),
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

          const SizedBox(height: 20),

          // Add button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_rounded),
              label: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                          CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Add to Timeline'),
              onPressed: _saving ? null : _save,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Coming-soon placeholder
// ─────────────────────────────────────────────────────────────────────────────

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
