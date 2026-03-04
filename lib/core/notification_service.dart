import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

/// Handles local push notifications for ClockIt.
///
/// Phase 2 note: Flutter Local Notifications v18 requires the `timezone`
/// package for scheduled (future) notifications via `zonedSchedule`.
/// We keep that dependency optional for now and deliver an immediate
/// "you have been clocked in" confirmation + a reminder that is shown
/// right away. Full scheduling will be wired in Phase 6 when we add
/// the `timezone` package.
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _androidDetails = AndroidNotificationDetails(
    'clockit_main',
    'ClockIt Notifications',
    channelDescription: 'General ClockIt app notifications.',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
    icon: '@mipmap/ic_launcher',
  );

  static const _notifDetails = NotificationDetails(android: _androidDetails);

  /// Initializes the plugin. Call once from [main] before [runApp].
  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);
    // Request notification permission on Android 13+.
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Shows a one-time confirmation when the user clocks in.
  Future<void> showClockInConfirmation(String expectedLogoutTime) async {
    await _plugin.show(
      1,
      'Clocked in ✅',
      'Expected logout: $expectedLogoutTime. Have a great shift!',
      _notifDetails,
    );
  }

  /// Shows a clock-out summary.
  Future<void> showClockOutSummary(String hoursWorked, bool isOvertime) async {
    final emoji = isOvertime ? '⏰' : '🏠';
    final label = isOvertime ? 'overtime' : 'early/on-time';
    await _plugin.show(
      2,
      'Clocked out $emoji',
      'You worked $hoursWorked today ($label). Great work!',
      _notifDetails,
    );
  }

  /// Cancels all active notifications.
  Future<void> cancelAll() => _plugin.cancelAll();
}

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}
