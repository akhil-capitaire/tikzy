import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tikzy/models/ticket_model.dart';
import 'package:tikzy/models/user_model.dart';
import 'package:tikzy/providers/ticket_provider.dart';
import 'package:tikzy/providers/user_list_provider.dart';
import 'package:tikzy/providers/user_provider.dart';
import 'package:tikzy/services/notification_services.dart';
import 'package:tikzy/services/ticket_services.dart';
import 'package:tikzy/services/user_services.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/utils/screen_size.dart';
import 'package:tikzy/utils/status_colors.dart';
import 'package:tikzy/widgets/buttons.dart';
import 'package:tikzy/widgets/custom_scaffold.dart';
import 'package:tikzy/widgets/dropdown.dart';
import 'package:tikzy/widgets/thumbnail_view.dart';

class TicketDetailPage extends ConsumerStatefulWidget {
  Ticket ticket;
  TicketDetailPage({super.key, required this.ticket});

  @override
  ConsumerState<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends ConsumerState<TicketDetailPage> {
  late String selectedStatus, selectedPriority, selectedAssignee;
  late DateTime selectedDueDate;
  late List<String> updatedAttachments;
  final commentController = TextEditingController();
  bool isModified = false;
  String assignedName = '';

  final statusOptions = ['Open', 'In Progress', 'Closed', 'On Hold'];
  final priorityOptions = ['Low', 'Medium', 'High'];
  final baseFontSize = 14.0;
  final dateFormat = DateFormat('MMM d, y');
  List<UserModel> assignees = [];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.ticket.status;
    selectedPriority = widget.ticket.priority;
    selectedDueDate = widget.ticket.dueDate!;
    selectedAssignee = widget.ticket.assignee;
    assignedName = widget.ticket.assignee;
    updatedAttachments = List.from(widget.ticket.attachments);
    fetchAssignee();
  }

  Future<void> fetchAssignee() async {
    assignees = await UserService().fetchUsers();
    final user = await UserService().fetchUserNameById(
      widget.ticket.assignedBy,
    );
    if (user != null) setState(() => assignedName = user);
  }

  Future<void> updateTicketChanges() async {
    final userData = ref.read(userLocalProvider);
    await TicketService().updateTicket(
      currentTicket: widget.ticket,
      updatedBy: userData!.id,
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

    await fetchAssignee();
    if (selectedAssignee.isNotEmpty) {
      await ref.read(userListProvider.notifier).loadUsers();
      final adminUsers =
          ref
              .read(userListProvider)
              .value
              ?.where((u) => u.role == 'Admin')
              .toList() ??
          [];
      for (final user in adminUsers) {
        await NotificationService().sendPushyNotification(
          title: 'New Ticket Assigned',
          deviceToken: user.pushyToken.toString(),
          message: 'A new ticket has been assigned by admin to you',
        );
      }
    }

    await ref.read(ticketNotifierProvider.notifier).loadTickets();
    widget.ticket =
        ref
            .read(ticketNotifierProvider)
            .value
            ?.firstWhere(
              (t) => t.id == widget.ticket.id,
              orElse: () => widget.ticket,
            ) ??
        widget.ticket;
    setState(() => isModified = false);
  }

  Widget buildMetaField(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _fieldLabelStyle),
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

  Widget buildDateField(
    String label,
    DateTime? date, {
    bool editable = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: InkWell(
      onTap: editable ? _pickDueDate : null,
      borderRadius: BorderRadius.circular(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _fieldLabelStyle),
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
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.edit_calendar,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
        showUpdateConfirmation("Due Date");
      });
    }
  }

  Widget buildDropdown(
    String label,
    List<String> options,
    String value,
    Color color,
    Function(String?) onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: _fieldLabelStyle),
      const SizedBox(height: 6),
      CustomDropdown(
        width: 200,
        height: 40,
        options: options,
        value: value.isEmpty ? null : value,
        fillColor: color,
        fontSize: baseFontSize,
        onChanged: onChanged,
      ),
    ],
  );

  Widget buildUpdateButton() => Align(
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

  Widget buildMetaCard() {
    final userData = ref.watch(userLocalProvider);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(commonPaddingSize),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildMetaField('Project', widget.ticket.projectName),
                  if (userData!.role == 'Admin') ...[
                    const SizedBox(height: 8),
                    Text("Assignee", style: _fieldLabelStyle),
                    const SizedBox(height: 6),
                    CustomDropdown(
                      height: 40,
                      width: 200,
                      options: assignees.map((user) => user.name).toList(),
                      value: selectedAssignee.isEmpty ? null : selectedAssignee,
                      fillColor: getStatusColor(selectedStatus),
                      fontSize: baseFontSize,
                      onChanged: (value) =>
                          value != null && value != selectedAssignee
                          ? setState(() {
                              selectedAssignee = value;
                              showUpdateConfirmation("Assignee");
                            })
                          : null,
                    ),
                  ],
                  const SizedBox(height: 12),
                  buildDateField('Due', selectedDueDate, editable: true),
                  const SizedBox(height: 8),
                  buildDropdown(
                    "Status",
                    statusOptions,
                    selectedStatus,
                    getStatusColor(selectedStatus),
                    (value) => value != null && value != selectedStatus
                        ? setState(() {
                            selectedStatus = value;
                            showUpdateConfirmation("Status");
                          })
                        : null,
                  ),
                  const SizedBox(height: 12),
                  buildDropdown(
                    "Priority",
                    priorityOptions,
                    selectedPriority,
                    getPriorityColor(selectedPriority),
                    (value) => value != null && value != selectedPriority
                        ? setState(() {
                            selectedPriority = value;
                            showUpdateConfirmation("Priority");
                          })
                        : null,
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
    final isMobile = MediaQuery.of(context).size.width < 1000;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description', style: _fieldLabelStyle),
            const SizedBox(height: 12),
            Text(
              widget.ticket.description,
              style: TextStyle(
                fontSize: baseFontSize + 1,
                color: Colors.grey.shade900,
                height: 1.4,
              ),
            ),
            if (!isMobile) ...[const SizedBox(height: 18), buildComments()],
            if (updatedAttachments.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Attachments', style: _fieldLabelStyle),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: updatedAttachments
                    .map(
                      (url) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ImageThumbnail(imageUrl: url, tag: 'image-$url'),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildComments() {
    final comments = widget.ticket.comments;
    final userList = ref.watch(userListProvider).value;
    if (comments == null || comments.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Comments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            CustomButton(
              label: 'Add Comment',
              onPressed: showAddCommentDialog,
              isSmall: true,
              type: ButtonType.outlined,
            ),
          ],
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
              final user = userList?.firstWhere(
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
                      getInitials(user!.name),
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
    );
  }

  Widget buildHistory() {
    final history = widget.ticket.history;
    if (history == null || history.isEmpty) return const SizedBox();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: const Text(
            'Ticket History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          children: [
            SizedBox(
              height: ScreenSize.height(35),
              child: ListView.separated(
                padding: EdgeInsets.all(commonPaddingSize),
                shrinkWrap: true,
                physics: ScrollPhysics(),
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
                                  if (entry.updatedByName.toString().isNotEmpty)
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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1000;
    return PopScope(
      onPopInvokedWithResult: (isPopped, result) {
        if (isPopped) {
          ref.read(ticketNotifierProvider.notifier).loadTickets();
        }
      },
      child: CustomScaffold(
        isScrollable: true,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1500,
              minWidth: 800,
              minHeight: 500,
            ),
            child: Padding(
              padding: EdgeInsets.all(commonPaddingSize),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ticket.title,
                      style: TextStyle(
                        fontSize: baseFontSize + 6,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    const SizedBox(height: 18),
                    isMobile
                        ? Column(
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
                              Expanded(flex: 6, child: buildDescriptionCard()),
                              const SizedBox(width: 32),
                              Expanded(flex: 6, child: buildHistory()),
                            ],
                          ),
                    if (isModified) ...[
                      const SizedBox(height: 18),
                      buildUpdateButton(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
  String getInitials(String name) =>
      name.trim().split(' ').take(2).map((p) => p[0].toUpperCase()).join();
  String formatDate(DateTime date) =>
      '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)} ${twoDigits(date.hour % 12 == 0 ? 12 : date.hour % 12)}:${twoDigits(date.minute)} ${date.hour >= 12 ? 'PM' : 'AM'}';
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  TextStyle get _fieldLabelStyle => TextStyle(
    fontSize: baseFontSize,
    fontWeight: FontWeight.w600,
    color: Colors.grey.shade600,
  );

  Future<void> showAddCommentDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Comment',
          style: TextStyle(fontSize: baseFontSize + 2),
        ),
        content: TextField(
          controller: commentController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter your comment here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          CustomButton(
            label: 'Cancel',
            onPressed: () async {
              Navigator.pop(context);
            },
            isSmall: true,
            type: ButtonType.secondary,
          ),
          CustomButton(
            label: 'Add',
            onPressed: () async {
              if (commentController.text.isNotEmpty) {
                await saveComment();
                Navigator.pop(context);
              }
            },
            isSmall: true,
            type: ButtonType.primary,
          ),
        ],
      ),
    );
  }

  Future<void> saveComment() async {
    final userData = ref.read(userLocalProvider);
    await TicketService().createComment(
      ticketId: widget.ticket.id,
      commentText: commentController.text,
      userId: userData!.id,
      authorName: userData.name,
    );
    await ref.read(ticketNotifierProvider.notifier).loadTickets();
    widget.ticket =
        ref
            .read(ticketNotifierProvider)
            .value
            ?.firstWhere(
              (t) => t.id == widget.ticket.id,
              orElse: () => widget.ticket,
            ) ??
        widget.ticket;
    setState(() => commentController.clear());
  }

  Future<void> showUpdateConfirmation(String text) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Update Confirmation',
          style: TextStyle(fontSize: baseFontSize + 2),
        ),
        content: Text(
          'Are you sure you want to update $text?',
          style: TextStyle(fontSize: baseFontSize),
        ),
        actions: [
          CustomButton(
            label: 'Cancel',
            onPressed: () async {
              Navigator.pop(context);
            },
            isSmall: true,
            type: ButtonType.secondary,
          ),
          CustomButton(
            label: 'Confirm',
            onPressed: () async {
              Navigator.pop(context);
              updateTicketChanges();
            },
            isSmall: true,
            type: ButtonType.primary,
          ),
        ],
      ),
    );
  }
}
