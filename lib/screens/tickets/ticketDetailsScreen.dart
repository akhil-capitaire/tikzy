import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tikzy/models/user_model.dart';
import 'package:tikzy/providers/ticket_provider.dart';
import 'package:tikzy/providers/user_provider.dart';
import 'package:tikzy/services/ticket_services.dart';
import 'package:tikzy/services/user_services.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/utils/spaces.dart';
import 'package:tikzy/widgets/dropdown.dart';

import '../../models/ticket_model.dart';
import '../../providers/user_list_provider.dart';
import '../../services/notification_services.dart';
import '../../utils/status_colors.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/thumbnail_view.dart';

class TicketDetailPage extends ConsumerStatefulWidget {
  final Ticket ticket;

  const TicketDetailPage({super.key, required this.ticket});

  @override
  ConsumerState<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends ConsumerState<TicketDetailPage> {
  late String selectedStatus;
  late String selectedPriority;
  late DateTime selectedDueDate;
  late List<String> updatedAttachments;

  bool isModified = false;

  final statusOptions = ['Open', 'In Progress', 'Closed', 'On Hold'];
  List<UserModel> assignees = [];
  String selectedAssignee = '';
  final priorityOptions = ['Low', 'Medium', 'High'];
  final baseFontSize = 14.0;
  final dateFormat = DateFormat('MMM d, y');
  String assignedName = '';
  @override
  void initState() {
    super.initState();
    selectedStatus = widget.ticket.status;
    selectedPriority = widget.ticket.priority;
    selectedDueDate = widget.ticket.dueDate!;
    selectedAssignee = widget.ticket.assignee;
    assignedName = widget.ticket.assignee;
    updatedAttachments = List<String>.from(widget.ticket.attachments);
    fetchAssignee();
  }

  fetchAssignee() async {
    assignees = await UserService().fetchUsers();
    final user = await UserService().fetchUserNameById(
      widget.ticket.assignedBy,
    );
    setState(() {});
    if (user != null) {}
  }

  void markModified() {
    setState(() => isModified = true);
  }

  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
        markModified();
      });
    }
  }

  Future<void> updateTicketChanges() async {
    await TicketService().updateTicket(
      ticketId: widget.ticket.id,
      dueDate: selectedDueDate,
      status: selectedStatus,
      priority: selectedPriority,
      assignee: selectedAssignee,
    );
    fetchAssignee();
    if (selectedAssignee.isNotEmpty) {
      await ref.read(userListProvider.notifier).loadUsers();
      final userlist = ref.read(userListProvider).value;
      print(userlist);
      final filteredUserList = (userlist ?? [])
          .where((element) => element.role == 'Admin')
          .toList();
      for (int i = 0; i < filteredUserList.length; i++) {
        await NotificationService().sendPushyNotification(
          title: 'New Ticket Assigned',
          deviceToken: filteredUserList[i].pushyToken.toString(),
          message: 'A new ticket has been assigned by admin to you',
        );
      }
    }
    ref.read(ticketNotifierProvider.notifier).loadTickets();
    setState(() => isModified = false);
  }

  void removeAttachment(String url) {
    setState(() {
      updatedAttachments.remove(url);
      markModified();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return CustomScaffold(
      isScrollable: true,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: EdgeInsets.all(commonPaddingSize),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(commonRadiusSize),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(commonPaddingSize),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.ticket.title,
                              style: TextStyle(
                                fontSize: baseFontSize + 4,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      sb(0, 1),

                      // Meta and Description
                      isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: buildDescriptionCard(),
                                ),
                                sb(0, 1),
                                buildMetaCard(),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 4, child: buildMetaCard()),
                                const SizedBox(width: 32),
                                Expanded(
                                  flex: 6,
                                  child: buildDescriptionCard(),
                                ),
                              ],
                            ),
                      if (isModified) sb(0, 1),
                      if (isModified) buildUpdateButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUpdateButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: updateTicketChanges,
        icon: const Icon(Icons.update, color: Colors.white),
        label: Text(
          'Update Ticket',
          style: TextStyle(fontSize: baseFontSize, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget buildMetaCard() {
    final userdata = ref.watch(userLocalProvider);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: EdgeInsets.all(commonPaddingSize),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT: Static Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  metaField('Project', widget.ticket.projectName),
                  if (widget.ticket.assignee.isNotEmpty)
                    metaField('Assigned to', assignedName),
                  metaField('Assigned By', 'Admin'),
                  dateField('Created', widget.ticket.createdDate),
                  if (widget.ticket.closedDate != null)
                    dateField('Closed', widget.ticket.closedDate!),
                  const SizedBox(height: 16),
                  dateField('Current Due', widget.ticket.dueDate),
                  metaField('Current Status', widget.ticket.status),
                  metaField('Current Priority', widget.ticket.priority),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // RIGHT: Editable Fields
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (userdata!.role == 'Admin')
                    Text("Change Assignee", style: fieldLabelStyle()),
                  if (userdata!.role == 'Admin') const SizedBox(height: 6),
                  if (userdata!.role == 'Admin')
                    CustomDropdown(
                      width: 200,
                      options: assignees.map((user) => user.name).toList(),
                      value: selectedAssignee,
                      fillColor: getStatusColor(selectedStatus),
                      fontSize: baseFontSize,
                      onChanged: (value) {
                        if (value != null && value != selectedAssignee) {
                          setState(() {
                            selectedAssignee = value;
                            markModified();
                          });
                        }
                      },
                    ),
                  const SizedBox(height: 12),
                  dateField('Change Due', selectedDueDate, editable: true),
                  const SizedBox(height: 8),
                  Text("Change Status", style: fieldLabelStyle()),
                  const SizedBox(height: 6),
                  CustomDropdown(
                    width: 200,
                    options: statusOptions,
                    value: selectedStatus,
                    fillColor: getStatusColor(selectedStatus),
                    fontSize: baseFontSize,
                    onChanged: (value) {
                      if (value != null && value != selectedStatus) {
                        setState(() {
                          selectedStatus = value;
                          markModified();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Text("Change Priority", style: fieldLabelStyle()),
                  const SizedBox(height: 6),
                  CustomDropdown(
                    width: 200,
                    options: priorityOptions,
                    value: selectedPriority,
                    fillColor: getPriorityColor(selectedPriority),
                    fontSize: baseFontSize,
                    onChanged: (value) {
                      if (value != null && value != selectedPriority) {
                        setState(() {
                          selectedPriority = value;
                          markModified();
                        });
                      }
                    },
                  ),
                ],
              ),
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
            Text('Description', style: fieldLabelStyle()),
            const SizedBox(height: 12),
            Text(
              widget.ticket.description,
              style: TextStyle(
                fontSize: baseFontSize + 1,
                color: Colors.grey.shade900,
                height: 1.4,
              ),
            ),
            if (updatedAttachments.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Attachments', style: fieldLabelStyle()),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: updatedAttachments.map((url) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),

                    child: ImageThumbnail(
                      imageUrl: url,
                      tag: 'sample-image-tag',
                    ),
                  );
                }).toList(),
              ),
            ],
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
          Text(label, style: fieldLabelStyle()),
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
            Text(label, style: fieldLabelStyle()),
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

  TextStyle fieldLabelStyle() {
    return TextStyle(
      fontSize: baseFontSize,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade600,
    );
  }
}
