import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/providers/user_list_provider.dart';
import 'package:tikzy/screens/users/user_widget.dart';

import '../../utils/routes.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_scaffold.dart';

class UserListPage extends ConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userListProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;
    return CustomScaffold(
      isScrollable: true,
      appBarButton: isMobile
          ? IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.adduserpage);
              },
              icon: Icon(Icons.add),
            )
          : CustomButton(
              label: 'Add User',
              onPressed: () async {
                Navigator.pushNamed(context, Routes.adduserpage);
              },
              type: ButtonType.primary,
              isSmall: true,
            ),
      body: userAsync.when(
        data: (users) => UserListBody(users: users),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
