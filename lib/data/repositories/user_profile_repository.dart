import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

part 'user_profile_repository.g.dart';

const _kOnboardingKey = 'onboarding_complete';

@riverpod
UserProfileRepository userProfileRepository(Ref ref) {
  final db = ref.read(appDatabaseProvider);
  return UserProfileRepository(db);
}

class UserProfileRepository {
  UserProfileRepository(this._db);
  final AppDatabase _db;

  /// Returns the first (and only) user profile, or null if not created yet.
  Future<UserProfile?> getProfile() =>
      _db.select(_db.userProfiles).getSingleOrNull();

  /// Saves a new or updated profile and marks onboarding as complete.
  Future<void> saveProfile(UserProfilesCompanion profile) async {
    await _db.into(_db.userProfiles).insertOnConflictUpdate(profile);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingKey, true);
  }
}
