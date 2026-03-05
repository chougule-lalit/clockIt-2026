import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:drift/drift.dart' show Value;

import '../../core/theme/app_theme.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../data/database/app_database.dart' show UserProfilesCompanion;


part 'onboarding_screen.g.dart';

// ─────────────────────────────────────────────
// State
// ─────────────────────────────────────────────

class OnboardingFormState {
  const OnboardingFormState({
    this.targetWorkHours = 8.0,
    this.targetBreakMins = 45,
    this.defaultStartHour = 9,
    this.defaultStartMinute = 30,
    this.notificationLeadMins = 15,
    this.isSaving = false,
  });

  final double targetWorkHours;
  final int targetBreakMins;
  final int defaultStartHour;
  final int defaultStartMinute;
  final int notificationLeadMins;
  final bool isSaving;

  OnboardingFormState copyWith({
    double? targetWorkHours,
    int? targetBreakMins,
    int? defaultStartHour,
    int? defaultStartMinute,
    int? notificationLeadMins,
    bool? isSaving,
  }) =>
      OnboardingFormState(
        targetWorkHours: targetWorkHours ?? this.targetWorkHours,
        targetBreakMins: targetBreakMins ?? this.targetBreakMins,
        defaultStartHour: defaultStartHour ?? this.defaultStartHour,
        defaultStartMinute: defaultStartMinute ?? this.defaultStartMinute,
        notificationLeadMins: notificationLeadMins ?? this.notificationLeadMins,
        isSaving: isSaving ?? this.isSaving,
      );
}

// ─────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingFormState build() => const OnboardingFormState();

  void setWorkHours(double v) => state = state.copyWith(targetWorkHours: v);
  void setBreakMins(int v) => state = state.copyWith(targetBreakMins: v);
  void setStartTime(int hour, int minute) =>
      state = state.copyWith(defaultStartHour: hour, defaultStartMinute: minute);
  void setLeadMins(int v) => state = state.copyWith(notificationLeadMins: v);

  Future<void> save() async {
    state = state.copyWith(isSaving: true);
    try {
      final repo = ref.read(userProfileRepositoryProvider);
      await repo.saveProfile(
        UserProfilesCompanion(
          targetWorkHours: Value(state.targetWorkHours),
          targetBreakHours: Value(state.targetBreakMins / 60.0),
          defaultStartHour: Value(state.defaultStartHour),
          defaultStartMinute: Value(state.defaultStartMinute),
          notificationLeadMins: Value(state.notificationLeadMins),
        ),
      );
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _workHoursCtrl;
  late final TextEditingController _breakMinsCtrl;

  @override
  void initState() {
    super.initState();
    final s = ref.read(onboardingNotifierProvider);
    _workHoursCtrl = TextEditingController(text: s.targetWorkHours.toString());
    _breakMinsCtrl = TextEditingController(text: s.targetBreakMins.toString());
  }

  @override
  void dispose() {
    _workHoursCtrl.dispose();
    _breakMinsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickStartTime() async {
    final s = ref.read(onboardingNotifierProvider);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: s.defaultStartHour, minute: s.defaultStartMinute),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx),
        child: child!,
      ),
    );
    if (picked != null) {
      ref
          .read(onboardingNotifierProvider.notifier)
          .setStartTime(picked.hour, picked.minute);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    notifier.setWorkHours(double.tryParse(_workHoursCtrl.text) ?? 8.0);
    notifier.setBreakMins(int.tryParse(_breakMinsCtrl.text) ?? 45);
    await notifier.save();
    if (mounted) context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingNotifierProvider);
    final startTime = TimeOfDay(
        hour: state.defaultStartHour, minute: state.defaultStartMinute);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                const SizedBox(height: 16),
                Text(
                  'ClockIt',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accentPrimary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Let's set up\nyour baseline.",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 32,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You can change these anytime in Settings.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 48),

                // ── Default Start Time ──
                _SectionLabel(label: 'Default Start Time'),
                const SizedBox(height: 8),
                _TappableField(
                  value: startTime.format(context),
                  icon: Icons.access_time_rounded,
                  onTap: _pickStartTime,
                ),
                const SizedBox(height: 24),

                // ── Target Working Hours ──
                _SectionLabel(label: 'Target Working Hours'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _workHoursCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 8 or 7.5',
                    suffixText: 'hrs',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    final n = double.tryParse(v);
                    if (n == null || n <= 0 || n > 24) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // ── Target Break Hours ──
                _SectionLabel(label: 'Target Break Time'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _breakMinsCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 45',
                    suffixText: 'mins',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    final n = int.tryParse(v);
                    if (n == null || n < 0) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // ── Notification Lead Time ──
                _SectionLabel(label: 'Notification Lead Time'),
                const SizedBox(height: 8),
                _LeadTimeDropdown(
                  value: state.notificationLeadMins,
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(onboardingNotifierProvider.notifier)
                          .setLeadMins(v);
                    }
                  },
                ),
                const SizedBox(height: 56),

                // ── CTA ──
                ElevatedButton(
                  onPressed: state.isSaving ? null : _save,
                  child: state.isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Save & Enter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Helper widgets
// ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: AppColors.textSecondary),
      );
}

class _TappableField extends StatelessWidget {
  const _TappableField({
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
}

class _LeadTimeDropdown extends StatelessWidget {
  const _LeadTimeDropdown({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.surface2,
          style: Theme.of(context).textTheme.bodyLarge,
          items: const [5, 10, 15, 30]
              .map((m) => DropdownMenuItem(
                    value: m,
                    child: Text('$m minutes before expected logout'),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
