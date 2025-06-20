import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/providers/user_list_provider.dart';
import 'package:tikzy/screens/users/user_widget.dart';

import '../../widgets/custom_scaffold.dart';

class UserListPage extends ConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userListProvider);

    return CustomScaffold(
      isScrollable: true,
      body: userAsync.when(
        data: (users) => UserListBody(users: users),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
