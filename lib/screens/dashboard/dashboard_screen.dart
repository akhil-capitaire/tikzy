import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/screens/dashboard/section_header.dart';
import 'package:tikzy/screens/dashboard/ticket_summarycard.dart';
import 'package:tikzy/services/auth_services.dart';
import 'package:tikzy/widgets/buttons.dart';

import '../../providers/ticket_provider.dart';
import '../../utils/fontsizes.dart';
import '../../utils/routes.dart';
import '../../utils/screen_size.dart';
import '../../utils/spaces.dart';
import '../tickets/ticket_row.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ScreenSize.width(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'Dashboard'),
                        sb(0, 2),
                        Wrap(
                          spacing: ScreenSize.width(2),
                          runSpacing: ScreenSize.height(1),
                          children: [
                            CustomButton(
                              label: 'Logout',
                              onPressed: () async {
                                await AuthService().signOut();
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.signin,
                                );
                              },
                              isSmall: true,
                              type: ButtonType.primary,
                            ),
                            CustomButton(
                              label: 'Ticket List',
                              onPressed: () async {
                                Navigator.pushNamed(
                                  context,
                                  Routes.ticketlistpage,
                                );
                              },
                              isSmall: true,
                              type: ButtonType.outlined,
                            ),
                            CustomButton(
                              label: 'Add User',
                              onPressed: () async {
                                Navigator.pushNamed(
                                  context,
                                  Routes.adduserpage,
                                );
                              },
                              isSmall: true,
                              type: ButtonType.secondary,
                            ),
                            CustomButton(
                              label: 'Add Ticket',
                              onPressed: () async {
                                Navigator.pushNamed(
                                  context,
                                  Routes.createticket,
                                );
                              },
                              isSmall: true,
                              type: ButtonType.primary,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SectionHeader(title: 'Dashboard'),
                        Wrap(
                          spacing: ScreenSize.width(2),
                          children: [
                            CustomButton(
                              label: 'Logout',
                              onPressed: () async {
                                await AuthService().signOut();
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.signin,
                                );
                              },
                              isSmall: true,
                              type: ButtonType.primary,
                            ),
                            CustomButton(
                              label: 'Ticket List',
                              onPressed: () async {
                                Navigator.pushNamed(
                                  context,
                                  Routes.ticketlistpage,
                                );
                              },
                              isSmall: true,
                              type: ButtonType.outlined,
                            ),
                            CustomButton(
                              label: 'Add User',
                              onPressed: () async {
                                Navigator.pushNamed(
                                  context,
                                  Routes.adduserpage,
                                );
                              },
                              isSmall: true,
                              type: ButtonType.secondary,
                            ),
                            CustomButton(
                              label: 'Add Ticket',
                              onPressed: () async {
                                Navigator.pushNamed(
                                  context,
                                  Routes.createticket,
                                );
                              },
                              isSmall: true,
                              type: ButtonType.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
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
        label: 'Pending Tickets',
        count: ref
            .read(ticketNotifierProvider.notifier)
            .getTicketCountByStatus('open'),
        color: Colors.orange,
      ),
      TicketSummaryCard(
        label: 'Closed Tickets',
        count: ref
            .read(ticketNotifierProvider.notifier)
            .getTicketCountByStatus('closed'),
        color: Colors.green,
      ),
      TicketSummaryCard(
        label: 'Important Tickets',
        count: ref
            .read(ticketNotifierProvider.notifier)
            .getImportanrTicketCount(),
        color: Colors.red,
      ),
      TicketSummaryCard(
        label: 'In Progress Tickets',
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

  Widget buildTicketList() {
    final tickets = ref.watch(ticketNotifierProvider).value;

    return ListView.separated(
      itemCount: tickets?.length ?? 0,
      separatorBuilder: (_, __) => sb(0, 2),
      itemBuilder: (_, index) {
        return TicketRow(ticket: tickets![index]);
      },
    );
  }
}
