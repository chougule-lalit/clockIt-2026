import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clockit/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('UserProfile can be written and read back from Drift', () async {
    // Arrange — build companion
    const companion = UserProfilesCompanion(
      targetWorkHours: Value(8.0),
      targetBreakHours: Value(0.75),
      defaultStartHour: Value(9),
      defaultStartMinute: Value(30),
      notificationLeadMins: Value(15),
    );

    // Act — write
    await db.into(db.userProfiles).insert(companion);

    // Assert — read back
    final results = await db.select(db.userProfiles).get();
    expect(results.length, 1);
    final profile = results.first;
    expect(profile.targetWorkHours, 8.0);
    expect(profile.targetBreakHours, 0.75);
    expect(profile.defaultStartHour, 9);
    expect(profile.defaultStartMinute, 30);
    expect(profile.notificationLeadMins, 15);
  });
}
