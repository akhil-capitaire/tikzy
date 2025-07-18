import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/providers/project_provider.dart';
import 'package:tikzy/providers/user_list_provider.dart';
import 'package:tikzy/providers/user_provider.dart';
import 'package:tikzy/screens/dashboard/section_header.dart';
import 'package:tikzy/screens/dashboard/ticket_summarycard.dart';
import 'package:tikzy/services/auth_services.dart';

import '../../providers/ticket_provider.dart';
import '../../utils/fontsizes.dart';
import '../../utils/routes.dart';
import '../../utils/screen_size.dart';
import '../../utils/spaces.dart';
import '../../widgets/custom_scaffold.dart';
import '../tickets/ticket_row.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(userLocalProvider.notifier).loadUserFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final tickets = ref.watch(ticketNotifierProvider);
    Widget buildTicketList() {
      return ListView.separated(
        itemCount: tickets.value?.length ?? 0,
        separatorBuilder: (_, __) => sb(0, 2),
        itemBuilder: (_, index) {
          return TicketRow(ticket: tickets.value![index]);
        },
      );
    }

    return CustomScaffold(
      isScrollable: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ScreenSize.width(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sb(0, 2),
              const SectionHeader(title: 'Dashboard'),
              sb(0, 3),
              buildSummaryCards(),
              sb(0, 4),
              const SectionHeader(title: 'Recent Tickets'),
              sb(0, 2),
              if (!isMobile) buildDesktopHeader(),
              Expanded(child: buildTicketList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDesktopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Title',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Project',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Created',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Due',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Closed',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Assignee',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Assigned By',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Priority',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCards() {
    final items = [
      TicketSummaryCard(
        label: 'Pending',
        count: ref
            .read(ticketNotifierProvider.notifier)
            .getTicketCountByStatus('open'),
        color: Colors.orange,
      ),
      TicketSummaryCard(
        label: 'Closed',
        count: ref
            .read(ticketNotifierProvider.notifier)
            .getTicketCountByStatus('closed'),
        color: Colors.green,
      ),
      TicketSummaryCard(
        label: 'Important',
        count: ref
            .read(ticketNotifierProvider.notifier)
            .getImportanrTicketCount(),
        color: Colors.red,
      ),
      TicketSummaryCard(
        label: 'In Progress',
        count: ref
            .read(ticketNotifierProvider.notifier)
            .getTicketCountByStatus('in progress'),
        color: Colors.blue,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return Wrap(
          spacing: ScreenSize.width(3),
          runSpacing: ScreenSize.height(2),
          children: items
              .map(
                (e) => SizedBox(
                  width: isWide
                      ? (constraints.maxWidth - ScreenSize.width(9)) / 4
                      : constraints.maxWidth / 2 - ScreenSize.width(4),
                  child: e,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class DashboardSidePanel extends StatelessWidget {
  final String role;
  final WidgetRef ref;

  const DashboardSidePanel({required this.role, required this.ref, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(commonPaddingSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Quick Actions", style: TextStyle(fontSize: baseFontSize)),
              sb(0, 2),
              ActionTile(
                icon: Icons.person,
                label: 'Profile',
                onTap: () => Navigator.pushNamed(context, Routes.profilepage),
              ),
              ActionTile(
                icon: Icons.list_alt,
                label: 'Ticket List',
                onTap: () =>
                    Navigator.pushNamed(context, Routes.ticketlistpage),
              ),
              ActionTile(
                icon: Icons.add_task,
                label: 'Add Ticket',
                onTap: () => Navigator.pushNamed(context, Routes.createticket),
              ),
              ActionTile(
                icon: Icons.logout,
                label: 'Logout',
                onTap: () async {
                  await AuthService().signOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, Routes.signin);
                  }
                },
              ),
              if (role == 'Admin') ...[
                const Divider(height: 32),
                Text("Admin Controls", style: textTheme.titleSmall),
                sb(0, 1.5),
                AdminActionCard(
                  children: [
                    ActionTile(
                      icon: Icons.group,
                      label: 'User List',
                      onTap: () {
                        ref.read(userListProvider.notifier).loadUsers();
                        Navigator.pushNamed(context, Routes.userlistpage);
                      },
                    ),
                    ActionTile(
                      icon: Icons.person_add,
                      label: 'Add User',
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.adduserpage),
                    ),
                    ActionTile(
                      icon: Icons.keyboard_tab_sharp,
                      label: 'Project List',
                      onTap: () {
                        ref.read(projectListProvider.notifier).loadProjects();
                        Navigator.pushNamed(context, Routes.projectlist);
                      },
                    ),
                    ActionTile(
                      icon: Icons.add,
                      label: 'Add New Project',
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.createproject),
                    ),
                    ActionTile(
                      icon: Icons.question_mark_sharp,
                      label: 'Unassigned Tickets',
                      onTap: () {
                        ref
                            .read(ticketNotifierProvider.notifier)
                            .unassignedTickets();
                        Navigator.pushNamed(context, Routes.ticketlistpage);
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: TextStyle(fontSize: baseFontSize)),
      onTap: onTap,
      hoverColor: theme.colorScheme.primary.withOpacity(0.1),
    );
  }
}

class AdminActionCard extends StatelessWidget {
  final List<Widget> children;

  const AdminActionCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: children),
      ),
    );
  }
}
