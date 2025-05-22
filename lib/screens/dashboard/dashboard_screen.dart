import 'package:flutter/material.dart';
import 'package:tikzy/screens/dashboard/section_header.dart';
import 'package:tikzy/screens/dashboard/ticket_summarycard.dart';
import 'package:tikzy/screens/tickets/ticket_row.dart';
import 'package:tikzy/widgets/buttons.dart';

import '../../utils/fontsizes.dart';
import '../../utils/routes.dart';
import '../../utils/screen_size.dart';
import '../../utils/spaces.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionHeader(title: 'Dashboard'),
                  Row(
                    children: [
                      CustomButton(
                        label: 'Ticket List',
                        onPressed: () async {
                          Navigator.pushNamed(context, Routes.ticketlistpage);
                        },
                        isSmall: true,
                        type: ButtonType.outlined,
                      ),
                      sb(2, 0),
                      CustomButton(
                        label: 'Add Ticket',
                        onPressed: () async {
                          Navigator.pushNamed(context, Routes.createticket);
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
        ],
      ),
    );
  }

  Widget buildSummaryCards() {
    final items = [
      TicketSummaryCard(
        label: 'Pending Tickets',
        count: 12,
        color: Colors.orange,
      ),
      TicketSummaryCard(
        label: 'Closed Tickets',
        count: 45,
        color: Colors.green,
      ),
      TicketSummaryCard(
        label: 'Important Tickets',
        count: 7,
        color: Colors.red,
      ),
      TicketSummaryCard(
        label: 'In Progress Tickets',
        count: 22,
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
    final tickets = List.generate(
      10,
      (index) => TicketRow(
        projectName: 'Project Alpha',
        title: 'Fix login bug',
        createdDate: DateTime(2024, 12, 1),
        dueDate: DateTime(2024, 12, 5),
        closedDate: index % 2 == 0 ? DateTime(2024, 12, 4) : null,
        assignee: 'John Doe',
        assignedBy: 'Jane Smith',
        status: index % 2 == 0 ? 'Closed' : 'Pending',
      ),
    );

    return ListView.separated(
      itemCount: tickets.length,
      separatorBuilder: (_, __) => sb(0, 2),
      itemBuilder: (_, index) => tickets[index],
    );
  }
}
