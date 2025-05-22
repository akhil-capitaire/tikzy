import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tikzy/widgets/dropdown.dart';

class TicketDetailPage extends StatefulWidget {
  final String ticketId;
  final String title;
  final String description;
  final String projectName;
  final String assignee;
  final String assignedBy;
  final DateTime createdDate;
  final DateTime? closedDate;
  final DateTime dueDate;
  final String status;

  const TicketDetailPage({
    super.key,
    required this.ticketId,
    required this.title,
    required this.description,
    required this.projectName,
    required this.assignee,
    required this.assignedBy,
    required this.createdDate,
    this.closedDate,
    required this.dueDate,
    required this.status,
  });

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  late String selectedStatus;
  late DateTime selectedDueDate;

  final statusOptions = ['Open', 'In Progress', 'Closed', 'On Hold'];
  final baseFontSize = 14.0;
  final dateFormat = DateFormat('MMM d, y');

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.status;
    selectedDueDate = widget.dueDate;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green.shade600;
      case 'in progress':
        return Colors.orange.shade600;
      case 'closed':
        return Colors.grey.shade600;
      case 'on hold':
        return Colors.blue.shade600;
      default:
        return Colors.black45;
    }
  }

  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket #${widget.ticketId}',
          style: TextStyle(
            fontSize: baseFontSize + 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: baseFontSize + 4,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Responsive layout: Meta + Description side by side or stacked
                    isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildMetaCard(),
                              const SizedBox(height: 24),
                              buildDescriptionCard(),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 4, child: buildMetaCard()),
                              const SizedBox(width: 32),
                              Expanded(flex: 6, child: buildDescriptionCard()),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMetaCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            metaField('Project', widget.projectName),
            metaField('Assignee', widget.assignee),
            metaField('Assigned By', widget.assignedBy),
            dateField('Created', widget.createdDate),
            dateField('Due', selectedDueDate, editable: true),
            if (widget.closedDate != null)
              dateField('Closed', widget.closedDate!),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status",
                  style: TextStyle(
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                CustomDropdown(
                  width: 200,
                  options: statusOptions,
                  value: selectedStatus,
                  fillColor: getStatusColor(selectedStatus),
                  fontSize: baseFontSize,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedStatus = value);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDescriptionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: baseFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: baseFontSize + 1,
                color: Colors.grey.shade900,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget metaField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: baseFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: baseFontSize + 1,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget dateField(String label, DateTime? date, {bool editable = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: InkWell(
        onTap: editable ? pickDueDate : null,
        borderRadius: BorderRadius.circular(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: baseFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  date != null ? dateFormat.format(date) : '-',
                  style: TextStyle(
                    fontSize: baseFontSize + 1,
                    color: Colors.grey.shade900,
                  ),
                ),
                if (editable)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.edit_calendar,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
