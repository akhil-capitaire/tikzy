import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/models/user_model.dart';

import '../services/user_services.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

final userListProvider =
    StateNotifierProvider<UserListNotifier, AsyncValue<List<UserModel>>>((ref) {
      final userService = ref.watch(userServiceProvider);
      return UserListNotifier(userService);
    });

class UserListNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final UserService _userService;

  UserListNotifier(this._userService) : super(const AsyncLoading()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final users = await _userService.fetchUsers();
      state = AsyncData(users);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  // In user_services.dart

  Future<void> deleteUser(String userId) async {
    await _userService.deleteUser(userId);
  }

  Future<void> refreshUsers() async => loadUsers();
}
