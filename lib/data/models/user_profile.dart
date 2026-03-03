import 'package:drift/drift.dart';

/// Drift table definition for [UserProfile].
class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Target total working hours per day (e.g. 8.0).
  RealColumn get targetWorkHours => real().withDefault(const Constant(8.0))();

  /// Target break hours per day (e.g. 0.75 for 45 min).
  RealColumn get targetBreakHours => real().withDefault(const Constant(0.75))();

  /// Default shift start hour in 24h format.
  IntColumn get defaultStartHour => integer().withDefault(const Constant(9))();

  /// Default shift start minute.
  IntColumn get defaultStartMinute => integer().withDefault(const Constant(30))();

  /// Minutes before expected logout to fire notification.
  IntColumn get notificationLeadMins => integer().withDefault(const Constant(15))();
}
