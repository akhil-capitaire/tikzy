import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/services/user_services.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/utils/screen_size.dart';

import '../../models/user_model.dart';
import '../../providers/user_list_provider.dart';

class UserListBody extends StatefulWidget {
  final List<UserModel> users;

  const UserListBody({required this.users});

  @override
  State<UserListBody> createState() => UserListBodyState();
}

class UserListBodyState extends State<UserListBody> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final filtered = widget.users
        .where(
          (u) =>
              u.name.toLowerCase().contains(search.toLowerCase()) ||
              u.email.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();

    if (widget.users.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    return Container(
      height: ScreenSize.screenHeight,
      child: Column(
        children: [
          if (isDesktop) const UserTableHeader(),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No users match your search.'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final user = filtered[index];
                      return isDesktop
                          ? UserTableRow(user: user)
                          : UserCard(user: user);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class UserTableHeader extends StatelessWidget {
  const UserTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: baseFontSize + 2,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Email',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: baseFontSize + 2,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Role',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: baseFontSize + 2,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: baseFontSize + 2,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserTableRow extends ConsumerWidget {
  final UserModel user;

  const UserTableRow({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {},
        hoverColor: Colors.grey.shade100,
        child: Container(
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: user.avatarUrl != null
                            ? NetworkImage(user.avatarUrl!)
                            : null,
                        child: user.avatarUrl == null
                            ? Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: baseFontSize,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: baseFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    user.email,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: baseFontSize,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.role,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: baseFontSize,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete User'),
                          content: Text(
                            'Are you sure you want to delete this user?',
                            style: TextStyle(fontSize: baseFontSize + 1),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                UserService().deleteUser(user.id);
                                ref.read(userListProvider.notifier).loadUsers();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserCard extends ConsumerWidget {
  final UserModel user;

  const UserCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: user.avatarUrl != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(user.avatarUrl.toString()),
              )
            : CircleAvatar(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: baseFontSize,
                  ),
                ),
              ),
        title: Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: baseFontSize + 1,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: baseFontSize,
              ),
            ),
            Text(
              user.role,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: baseFontSize,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete User'),
                  content: Text(
                    'Are you sure you want to delete this user?',
                    style: TextStyle(fontSize: baseFontSize + 1),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        UserService().deleteUser(user.id);
                        ref.read(userListProvider.notifier).loadUsers();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ),
        onTap: () {
          // TODO: navigate to user detail/edit
        },
      ),
    );
  }
}
