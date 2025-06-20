import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/widgets/custom_scaffold.dart';

import '../../providers/user_provider.dart' show userLocalProvider;

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userLocalProvider);
    final dateFormat = DateFormat('yMMMd').add_jm();

    return user == null
        ? const Center(child: Text('No user data available.'))
        : LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final cardWidth = isMobile ? constraints.maxWidth * 0.9 : 500.0;

              return CustomScaffold(
                // appBar: isMobile
                //     ? AppBar(
                //         centerTitle: true,
                //         title: Text(
                //           'Profile',
                //           style: TextStyle(fontSize: baseFontSize + 4),
                //         ),
                //         leading: IconButton(
                //           onPressed: () {
                //             Navigator.pop(context);
                //           },
                //           icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                //         ),
                //       )
                //     : null,
                body: Center(
                  child: Card(
                    color: Colors.grey.shade50,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(commonRadiusSize),
                    ),
                    child: SizedBox(
                      width: cardWidth,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundImage: user.avatarUrl != null
                                  ? NetworkImage(user.avatarUrl!)
                                  : null,
                              child: user.avatarUrl == null
                                  ? Text(
                                      user.name[0],
                                      style: TextStyle(
                                        fontSize: baseFontSize + 10,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.name,
                              style: TextStyle(fontSize: baseFontSize + 2),
                            ),
                            Text(
                              user.email,
                              style: TextStyle(fontSize: baseFontSize),
                            ),
                            const SizedBox(height: 24),
                            InfoTile(title: 'Role', value: user.role),
                            if (user.createdAt != null)
                              InfoTile(
                                title: 'Joined',
                                value: dateFormat.format(
                                  user.createdAt!.toDate(),
                                ),
                              ),
                            if (user.updatedAt != null)
                              InfoTile(
                                title: 'Last Updated',
                                value: dateFormat.format(
                                  user.updatedAt!.toDate(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ', style: TextStyle(fontSize: baseFontSize)),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: baseFontSize)),
          ),
        ],
      ),
    );
  }
}
