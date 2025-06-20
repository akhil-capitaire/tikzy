import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/utils/spaces.dart';

import '../../models/ticket_model.dart';
import '../../services/user_services.dart';
import '../../utils/routes.dart';
import '../../utils/status_colors.dart';

class TicketRow extends StatefulWidget {
  final Ticket ticket;

  const TicketRow({super.key, required this.ticket});

  @override
  State<TicketRow> createState() => _TicketRowState();
}

class _TicketRowState extends State<TicketRow> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAssigneeName();
  }

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
          Navigator.pushNamed(
            context,
            Routes.ticketdetailpage,
            arguments: {'ticket': widget.ticket},
          );
        },
        child: Container(
          padding: EdgeInsets.all(commonPaddingSize),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
          ),
          child: Row(
            children: [
              cell(widget.ticket.title, flex: 2),
              cell(widget.ticket.projectName, flex: 2),
              cell(dateFormat.format(widget.ticket.createdDate as DateTime)),
              cell(
                widget.ticket.dueDate != null
                    ? dateFormat.format(widget.ticket.dueDate!)
                    : '-',
              ),
              cell(
                widget.ticket.closedDate != null
                    ? dateFormat.format(widget.ticket.closedDate!)
                    : '-',
              ),
              cell(widget.ticket.assignee),
              cell('Admin'),
              statusPill(widget.ticket.status),

              priorityPill(widget.ticket.priority),
            ],
          ),
        ),
      ),
    );
  }

  String assignedName = '';
  fetchAssigneeName() async {
    final user = await UserService().fetchUserNameById(
      widget.ticket.assignedBy,
    );
    if (user != null) {
      setState(() {
        assignedName = user;
      });
    }
  }

  Widget priorityPill(String priority) {
    final color = getPriorityColor(priority);
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
            priority,
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
    final statusColor = getStatusColor(widget.ticket.status);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.ticketdetailpage,
          arguments: {'ticket': widget.ticket},
        );
      },
      child: Container(
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
                    widget.ticket.title,
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
                    widget.ticket.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
                sb(10, 0),
                priorityPill(widget.ticket.priority),
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
                    widget.ticket.projectName,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.ticket.assignee,
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
                  dateFormat.format(widget.ticket.createdDate as DateTime),
                  style: const TextStyle(fontSize: 13),
                ),
                if (widget.ticket.dueDate != null) ...[
                  const SizedBox(width: 12),
                  const Icon(Icons.schedule, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(widget.ticket.dueDate!),
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ],
            ),

            if (widget.ticket.closedDate != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "Closed: ${dateFormat.format(widget.ticket.closedDate!)}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 4),

            /// Assigned By
            Text(
              "Assigned by ${assignedName}",
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
