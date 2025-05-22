import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/status_colors.dart';
import 'ticketDetailsScreen.dart';

class TicketRow extends StatefulWidget {
  final String projectName;
  final String title;
  final DateTime createdDate;
  final DateTime? dueDate;
  final DateTime? closedDate;
  final String assignee;
  final String assignedBy;
  final String status;

  const TicketRow({
    super.key,
    required this.projectName,
    required this.title,
    required this.createdDate,
    this.dueDate,
    this.closedDate,
    required this.assignee,
    required this.assignedBy,
    required this.status,
  });

  @override
  State<TicketRow> createState() => _TicketRowState();
}

class _TicketRowState extends State<TicketRow> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return isMobile ? mobileLayout(context) : desktopLayout();
  }

  Widget desktopLayout() {
    final dateFormat = DateFormat('dd MMM');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TicketDetailPage(
                ticketId: '123',
                title: 'Crash on login',
                projectName: 'CRM App',
                description:
                    'User reports a crash when tapping login on iOS 17.',
                createdDate: DateTime(2024, 5, 1),
                dueDate: DateTime(2024, 5, 10),
                closedDate: null,
                assignee: 'Akhil',
                assignedBy: 'John',
                status: 'In Progress',
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
          ),
          child: Row(
            children: [
              cell(widget.title, flex: 2),
              cell(widget.projectName, flex: 2),
              cell(dateFormat.format(widget.createdDate)),
              cell(
                widget.dueDate != null
                    ? dateFormat.format(widget.dueDate!)
                    : '-',
              ),
              cell(
                widget.closedDate != null
                    ? dateFormat.format(widget.closedDate!)
                    : '-',
              ),
              cell(widget.assignee),
              cell(widget.assignedBy),
              statusPill(widget.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget statusPill(String status) {
    final color = getStatusColor(status);
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget mobileLayout(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final statusColor = getStatusColor(widget.status);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TicketDetailPage(
              ticketId: '123',
              title: 'Crash on login',
              projectName: 'CRM App',
              description: 'User reports a crash when tapping login on iOS 17.',
              createdDate: DateTime(2024, 5, 1),
              dueDate: DateTime(2024, 5, 10),
              closedDate: null,
              assignee: 'Akhil',
              assignedBy: 'John',
              status: 'In Progress',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// Project + Assignee
            Row(
              children: [
                const Icon(Icons.folder_open, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.projectName,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.assignee,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            /// Dates Row
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  dateFormat.format(widget.createdDate),
                  style: const TextStyle(fontSize: 13),
                ),
                if (widget.dueDate != null) ...[
                  const SizedBox(width: 12),
                  const Icon(Icons.schedule, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(widget.dueDate!),
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ],
            ),

            if (widget.closedDate != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "Closed: ${dateFormat.format(widget.closedDate!)}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 4),

            /// Assigned By
            Text(
              "Assigned by ${widget.assignedBy}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget cell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget statusCell(String status) {
    final color = getStatusColor(status);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
