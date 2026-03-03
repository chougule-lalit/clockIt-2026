import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

/// Home screen stub — Phase 1 scaffold.
/// Full Clock-In/Out + Timeline will be implemented in Phase 2.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const _labels = [
    'Home',
    'Tasks',
    'Timer',
    'Analytics',
    'Reports',
    'Settings',
  ];

  static const _icons = [
    Icons.home_rounded,
    Icons.checklist_rounded,
    Icons.timer_rounded,
    Icons.bar_chart_rounded,
    Icons.description_rounded,
    Icons.settings_rounded,
  ];

  void _onNavTap(int index) {
    if (index == 5) {
      // Settings
      context.goNamed('settings');
      return;
    }
    setState(() => _selectedIndex = index);
  }

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
        onDestinationSelected: _onNavTap,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: _labels.asMap().entries.map((e) {
          // Skip Settings in nav bar since it opens on tap
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

// ── Home Body — Phase 1 placeholder ──

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Smart Clock card (stub)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Smart Clock',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(letterSpacing: 1.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                // Pill toggle stub
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PillToggle(label: 'Clock In', isActive: true),
                      _PillToggle(label: 'Clock Out', isActive: false),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Phase 2: Shift Tracking',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textPlaceholder),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Timeline stub
          Text(
            "Today's Timeline",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          ...List.generate(5, (i) => _TimelineSlotStub(hour: 9 + i)),
        ],
      ),
    );
  }
}

class _PillToggle extends StatelessWidget {
  const _PillToggle({required this.label, required this.isActive});
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
        ),
      );
}

class _TimelineSlotStub extends StatelessWidget {
  const _TimelineSlotStub({required this.hour});
  final int hour;

  @override
  Widget build(BuildContext context) {
    final label = hour < 12
        ? '$hour:00 AM'
        : hour == 12
            ? '12:00 PM'
            : '${hour - 12}:00 PM';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 52,
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textPlaceholder, fontSize: 10)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.divider, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: Text(
                '+ Tap to log a task',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPlaceholder,
                      fontSize: 12,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Generic coming-soon placeholder ──

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
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming in a future phase.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textPlaceholder),
            ),
          ],
        ),
      );
}
