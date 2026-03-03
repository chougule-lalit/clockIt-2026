import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' show Value;

import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart'
    show TimesheetBucket, UserProfilesCompanion;
import '../../data/repositories/timesheet_bucket_repository.dart';
import '../../data/repositories/user_profile_repository.dart';


part 'settings_screen.g.dart';

// ─────────────────────────────────────────────
// Settings Form State
// ─────────────────────────────────────────────

class SettingsFormState {
  const SettingsFormState({
    this.targetWorkHours = 8.0,
    this.targetBreakHours = 0.75,
    this.defaultStartHour = 9,
    this.defaultStartMinute = 30,
    this.notificationLeadMins = 15,
    this.biometricEnabled = false,
    this.isSaving = false,
    this.isLoaded = false,
  });

  final double targetWorkHours;
  final double targetBreakHours;
  final int defaultStartHour;
  final int defaultStartMinute;
  final int notificationLeadMins;
  final bool biometricEnabled;
  final bool isSaving;
  final bool isLoaded;

  SettingsFormState copyWith({
    double? targetWorkHours,
    double? targetBreakHours,
    int? defaultStartHour,
    int? defaultStartMinute,
    int? notificationLeadMins,
    bool? biometricEnabled,
    bool? isSaving,
    bool? isLoaded,
  }) =>
      SettingsFormState(
        targetWorkHours: targetWorkHours ?? this.targetWorkHours,
        targetBreakHours: targetBreakHours ?? this.targetBreakHours,
        defaultStartHour: defaultStartHour ?? this.defaultStartHour,
        defaultStartMinute: defaultStartMinute ?? this.defaultStartMinute,
        notificationLeadMins: notificationLeadMins ?? this.notificationLeadMins,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        isSaving: isSaving ?? this.isSaving,
        isLoaded: isLoaded ?? this.isLoaded,
      );
}

// ─────────────────────────────────────────────
// Settings Notifier
// ─────────────────────────────────────────────

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsFormState build() {
    _loadProfile();
    return const SettingsFormState();
  }

  Future<void> _loadProfile() async {
    final repo = ref.read(userProfileRepositoryProvider);
    final p = await repo.getProfile();
    if (p != null) {
      state = SettingsFormState(
        targetWorkHours: p.targetWorkHours,
        targetBreakHours: p.targetBreakHours,
        defaultStartHour: p.defaultStartHour,
        defaultStartMinute: p.defaultStartMinute,
        notificationLeadMins: p.notificationLeadMins,
        isLoaded: true,
      );
    } else {
      state = state.copyWith(isLoaded: true);
    }
  }

  void setWorkHours(double v) => state = state.copyWith(targetWorkHours: v);
  void setBreakHours(double v) => state = state.copyWith(targetBreakHours: v);
  void setStartTime(int h, int m) =>
      state = state.copyWith(defaultStartHour: h, defaultStartMinute: m);
  void setLeadMins(int v) => state = state.copyWith(notificationLeadMins: v);
  void setBiometric(bool v) => state = state.copyWith(biometricEnabled: v);

  Future<void> save() async {
    state = state.copyWith(isSaving: true);
    try {
      final repo = ref.read(userProfileRepositoryProvider);
      await repo.saveProfile(
        UserProfilesCompanion(
          targetWorkHours: Value(state.targetWorkHours),
          targetBreakHours: Value(state.targetBreakHours),
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
// Buckets Notifier
// ─────────────────────────────────────────────

@riverpod
class BucketsNotifier extends _$BucketsNotifier {
  @override
  Future<List<TimesheetBucket>> build() async {
    final repo = ref.read(timesheetBucketRepositoryProvider);
    return repo.getAll();
  }

  Future<void> add(String name) async {
    final repo = ref.read(timesheetBucketRepositoryProvider);
    await repo.add(name);
    ref.invalidateSelf();
  }

  Future<void> delete(int id) async {
    final repo = ref.read(timesheetBucketRepositoryProvider);
    await repo.delete(id);
    ref.invalidateSelf();
  }
}

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _workHoursCtrl;
  late TextEditingController _breakHoursCtrl;
  bool _controllersInit = false;

  @override
  void dispose() {
    if (_controllersInit) {
      _workHoursCtrl.dispose();
      _breakHoursCtrl.dispose();
    }
    super.dispose();
  }

  void _initControllers(SettingsFormState s) {
    if (!_controllersInit) {
      _workHoursCtrl = TextEditingController(text: s.targetWorkHours.toString());
      _breakHoursCtrl = TextEditingController(text: s.targetBreakHours.toString());
      _controllersInit = true;
    }
  }

  Future<void> _pickStartTime(SettingsFormState s) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: s.defaultStartHour, minute: s.defaultStartMinute),
    );
    if (picked != null) {
      ref
          .read(settingsNotifierProvider.notifier)
          .setStartTime(picked.hour, picked.minute);
    }
  }

  Future<void> _save(SettingsFormState s) async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(settingsNotifierProvider.notifier);
    notifier.setWorkHours(double.tryParse(_workHoursCtrl.text) ?? s.targetWorkHours);
    notifier.setBreakHours(double.tryParse(_breakHoursCtrl.text) ?? s.targetBreakHours);
    await notifier.save();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Settings saved'),
          backgroundColor: AppColors.surface2,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Future<void> _showAddBucketDialog() async {
    final ctrl = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface2,
        title: const Text('Add Timesheet Bucket'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: Theme.of(ctx).textTheme.bodyLarge,
          decoration: const InputDecoration(hintText: 'e.g. Project A - Billable'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(bucketsNotifierProvider.notifier).add(ctrl.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsNotifierProvider);
    final bucketsAsync = ref.watch(bucketsNotifierProvider);

    if (!settingsState.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    _initControllers(settingsState);

    final startTime = TimeOfDay(
        hour: settingsState.defaultStartHour,
        minute: settingsState.defaultStartMinute);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            // ── Profile Section ──
            _SectionHeader(label: 'Work Profile'),
            const SizedBox(height: 12),
            _SettingsCard(children: [
              _SettingsRow(
                label: 'Default Start Time',
                trailing: GestureDetector(
                  onTap: () => _pickStartTime(settingsState),
                  child: Text(
                    startTime.format(context),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.accentPrimary),
                  ),
                ),
              ),
              const Divider(),
              _InlineTextInput(
                label: 'Target Work Hours',
                controller: _workHoursCtrl,
                suffix: 'hrs',
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return 'Invalid';
                  return null;
                },
              ),
              const Divider(),
              _InlineTextInput(
                label: 'Target Break Hours',
                controller: _breakHoursCtrl,
                suffix: 'hrs',
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final n = double.tryParse(v);
                  if (n == null || n < 0) return 'Invalid';
                  return null;
                },
              ),
              const Divider(),
              _SettingsRow(
                label: 'Notification Lead Time',
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: settingsState.notificationLeadMins,
                    dropdownColor: AppColors.surface2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.accentPrimary),
                    items: const [5, 10, 15, 30]
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text('$m min'),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        ref
                            .read(settingsNotifierProvider.notifier)
                            .setLeadMins(v);
                      }
                    },
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 28),

            // ── Timesheet Buckets ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionHeader(label: 'Timesheet Buckets'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.accentPrimary),
                  tooltip: 'Add bucket',
                  onPressed: _showAddBucketDialog,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Map company timesheet categories to quick-select chips.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            bucketsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Text('Error: $e'),
              data: (buckets) => buckets.isEmpty
                  ? _SettingsCard(children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'No buckets yet. Tap + to add your organisation\'s categories.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textPlaceholder),
                          ),
                        ),
                      ),
                    ])
                  : _SettingsCard(
                      children: buckets
                          .asMap()
                          .entries
                          .expand((e) => [
                                if (e.key > 0) const Divider(),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  title: Text(
                                    e.value.officialName,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: AppColors.danger, size: 20),
                                    onPressed: () => ref
                                        .read(bucketsNotifierProvider.notifier)
                                        .delete(e.value.id),
                                  ),
                                ),
                              ])
                          .toList(),
                    ),
            ),

            const SizedBox(height: 28),

            // ── Security ──
            _SectionHeader(label: 'Security'),
            const SizedBox(height: 12),
            _SettingsCard(children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text('Require Biometric Unlock',
                    style: Theme.of(context).textTheme.bodyMedium),
                subtitle: Text('FaceID / Fingerprint on launch',
                    style: Theme.of(context).textTheme.bodySmall),
                value: settingsState.biometricEnabled,
                onChanged: (v) =>
                    ref.read(settingsNotifierProvider.notifier).setBiometric(v),
              ),
            ]),

            const SizedBox(height: 28),

            // ── Data Management ──
            _SectionHeader(label: 'Data Management'),
            const SizedBox(height: 12),
            _SettingsCard(children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                title: Text('Export Local Database Backup',
                    style: Theme.of(context).textTheme.bodyMedium),
                trailing: const Icon(Icons.download_outlined,
                    color: AppColors.textSecondary, size: 20),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Backup export coming in Phase 6')));
                },
              ),
              const Divider(),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                title: const Text('Wipe All Data',
                    style: TextStyle(color: AppColors.danger)),
                trailing: const Icon(Icons.warning_amber_rounded,
                    color: AppColors.danger, size: 20),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Wipe All Data coming in Phase 6')));
                },
              ),
            ]),
          ],
        ),
      ),
      // ── Floating Save Bar ──
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        color: AppColors.appBackground,
        child: ElevatedButton(
          onPressed: settingsState.isSaving ? null : () => _save(settingsState),
          child: settingsState.isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Save Settings'),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Helper widgets
// ─────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
      );
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: children,
        ),
      );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, required this.trailing});
  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            trailing,
          ],
        ),
      );
}

class _InlineTextInput extends StatelessWidget {
  const _InlineTextInput({
    required this.label,
    required this.controller,
    required this.suffix,
    required this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String suffix;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(
              width: 100,
              child: TextFormField(
                controller: controller,
                textAlign: TextAlign.end,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.accentPrimary),
                decoration: InputDecoration(
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  suffixText: suffix,
                  suffixStyle: Theme.of(context).textTheme.bodySmall,
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.accentPrimary.withValues(alpha: 0.6)),
                  ),
                ),
                validator: validator,
              ),
            ),
          ],
        ),
      );
}
