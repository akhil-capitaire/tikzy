import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/models/user_model.dart';
import 'package:tikzy/utils/shared_preference.dart';

final userLocalProvider = StateNotifierProvider<UserLocalNotifier, UserModel?>((
  ref,
) {
  return UserLocalNotifier();
});

class UserLocalNotifier extends StateNotifier<UserModel?> {
  UserLocalNotifier() : super(null) {
    loadUserFromPrefs();
  }

  Future<void> loadUserFromPrefs() async {
    final user = await SharedPreferenceUtils.getUserModel();
    if (user != null) state = user;
  }

  Future<void> setUser(UserModel user) async {
    await SharedPreferenceUtils.saveUserModel(user);
    state = user;
  }

  Future<void> clearUser() async {
    await SharedPreferenceUtils.clearUserModel();
    state = null;
  }
}
