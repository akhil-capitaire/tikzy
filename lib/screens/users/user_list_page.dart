import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/providers/user_list_provider.dart';
import 'package:tikzy/screens/users/user_widget.dart';

import '../../utils/fontsizes.dart';

class UserListPage extends ConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userListProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: Text(
                'Users',
                style: TextStyle(fontSize: baseFontSize + 4),
              ),
            )
          : null,
      body: userAsync.when(
        data: (users) => UserListBody(users: users),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
