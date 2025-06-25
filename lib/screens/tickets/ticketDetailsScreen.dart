import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tikzy/models/user_model.dart';
import 'package:tikzy/providers/ticket_provider.dart';
import 'package:tikzy/providers/user_provider.dart';
import 'package:tikzy/services/ticket_services.dart';
import 'package:tikzy/services/user_services.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/utils/screen_size.dart';
import 'package:tikzy/widgets/buttons.dart';
import 'package:tikzy/widgets/dropdown.dart';
import 'package:tikzy/widgets/form_input.dart';

import '../../models/ticket_model.dart';
import '../../providers/user_list_provider.dart';
import '../../services/notification_services.dart';
import '../../utils/status_colors.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/thumbnail_view.dart';

class TicketDetailPage extends ConsumerStatefulWidget {
  Ticket ticket;

  TicketDetailPage({super.key, required this.ticket});

  @override
  ConsumerState<TicketDetailPage> createState() => TicketDetailPageState();
}

class TicketDetailPageState extends ConsumerState<TicketDetailPage> {
  late String selectedStatus;
  late String selectedPriority;
  late DateTime selectedDueDate;
  late List<String> updatedAttachments;
  final commentController = TextEditingController();
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
    setState(() {
      if (user != null) assignedName = user;
    });
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
    final userdata = ref.watch(userLocalProvider);
    await TicketService().updateTicket(
      currentTicket: widget.ticket,
      updatedBy: userdata!.id,
      ticketId: widget.ticket.id,
      dueDate: widget.ticket.dueDate == selectedDueDate
          ? null
          : selectedDueDate,
      status: widget.ticket.status == selectedStatus ? null : selectedStatus,
      priority: widget.ticket.priority == selectedPriority
          ? null
          : selectedPriority,
      assignee: widget.ticket.assignee == selectedAssignee
          ? null
          : selectedAssignee,
    );
    fetchAssignee();
    if (selectedAssignee.isNotEmpty) {
      await ref.read(userListProvider.notifier).loadUsers();
      final userlist = ref.read(userListProvider).value;
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
    await ref.read(ticketNotifierProvider.notifier).loadTickets();
    final List<Ticket>? ticketlist = ref.read(ticketNotifierProvider).value;
    final ticket = ticketlist?.firstWhere(
      (u) => u.id == widget.ticket.id,
      orElse: () => Ticket(
        id: '',
        title: '',
        description: '',
        projectName: '',
        assignee: '',
        assignedBy: '',
        status: '',
        priority: '',
      ),
    );
    widget.ticket = ticket!;
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
    final isMobile = screenWidth < 1000;

    return CustomScaffold(
      isScrollable: true,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
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
                                fontSize: baseFontSize + 6,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Meta and Description
                      isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildMetaCard(),
                                const SizedBox(height: 18),
                                buildDescriptionCard(),
                                const SizedBox(height: 18),
                                buildComments(),
                                const SizedBox(height: 18),
                                buildHistory(),
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
                                const SizedBox(width: 32),
                                Expanded(flex: 6, child: buildHistory()),
                              ],
                            ),

                      if (isModified) const SizedBox(height: 18),
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

  Widget buildHistory() {
    final history = widget.ticket.history;
    if (history == null || history.isEmpty) {
      return const SizedBox();
    }
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ticket History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: ScreenSize.height(30),
              child: ListView.separated(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: history.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final entry = history[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.history,
                        size: 20,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.message,
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (entry.createdDate != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      formatDate(entry.createdDate!),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Updated by: ${entry.updatedByName}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildComments() {
    final comments = widget.ticket.comments;
    final userlist = ref.watch(userListProvider).value;
    if (comments == null || comments.isEmpty) {
      return const SizedBox();
    }
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: ScreenSize.height(25),
              child: ListView.separated(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: comments.length,
                separatorBuilder: (_, __) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  final user = userlist?.firstWhere(
                    (u) => u.id == comment.author,
                    orElse: () => UserModel(
                      id: comment.author,
                      name: 'Unknown',
                      email: '',
                      role: '',
                    ),
                  );
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child: Text(
                          _getInitials(user!.name),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment.comment,
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (comment.createdDate != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  formatDate(comment.createdDate!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  String formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} ${_twoDigits(date.hour % 12 == 0 ? 12 : date.hour % 12)}:${_twoDigits(date.minute)} ${date.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

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
                  if (userdata.role == 'Admin') const SizedBox(height: 6),
                  if (userdata.role == 'Admin')
                    CustomDropdown(
                      width: 200,
                      options: assignees.map((user) => user.name).toList(),
                      value: (selectedAssignee.isEmpty)
                          ? null
                          : selectedAssignee,
                      fillColor: getStatusColor(selectedStatus),
                      fontSize: baseFontSize,
                      // hint: const Text('select', style: TextStyle(color: Colors.grey)),
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
                    value: (selectedStatus.isEmpty) ? null : selectedStatus,
                    fillColor: getStatusColor(selectedStatus),
                    fontSize: baseFontSize,
                    // hint: const Text('select', style: TextStyle(color: Colors.grey)),
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
                    value: (selectedPriority.isEmpty) ? null : selectedPriority,
                    fillColor: getPriorityColor(selectedPriority),
                    fontSize: baseFontSize,
                    // hint: const Text('select', style: TextStyle(color: Colors.grey)),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1000;
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
            const SizedBox(height: 18),
            Text('Comment', style: fieldLabelStyle()),
            const SizedBox(height: 12),
            FormDescription(
              controller: commentController,
              hintText: 'Add a comment',
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            if (commentController.text.isNotEmpty)
              CustomButton(
                label: 'Save',
                onPressed: saveComment,
                isSmall: false,
                type: ButtonType.outlined,
              ),
            if (!isMobile) ...[const SizedBox(height: 18), buildComments()],
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

  Future<void> saveComment() async {
    final userdata = ref.watch(userLocalProvider);
    await TicketService().createComment(
      ticketId: widget.ticket.id,
      commentText: commentController.text,
      userId: userdata!.id,
      authorName: userdata.name,
    );
    await ref.read(ticketNotifierProvider.notifier).loadTickets();
    final List<Ticket>? ticketlist = ref.read(ticketNotifierProvider).value;
    final ticket = ticketlist?.firstWhere(
      (u) => u.id == widget.ticket.id,
      orElse: () => Ticket(
        id: '',
        title: '',
        description: '',
        projectName: '',
        assignee: '',
        assignedBy: '',
        status: '',
        priority: '',
      ),
    );
    widget.ticket = ticket!;
    setState(() {
      commentController.clear();
    });
  }
}
