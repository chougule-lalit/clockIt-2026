import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'scratchpad_repository.g.dart';

@Riverpod(keepAlive: true)
ScratchpadRepository scratchpadRepository(Ref ref) {
  return ScratchpadRepository();
}

/// Persists the scratchpad text as a single string in SharedPreferences.
class ScratchpadRepository {
  static const _key = 'scratchpad_text';

  Future<String> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? '';
  }

  Future<void> save(String text) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, text);
  }
}
