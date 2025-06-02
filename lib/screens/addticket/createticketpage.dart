import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tikzy/services/ticket_services.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/utils/spaces.dart';
import 'package:tikzy/widgets/buttons.dart';
import 'package:tikzy/widgets/form_input.dart';

import '../../providers/ticket_provider.dart';
import '../../utils/status_colors.dart';
import '../../widgets/dropdown.dart';

class CreateTicketPage extends ConsumerStatefulWidget {
  const CreateTicketPage({super.key});

  @override
  ConsumerState<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends ConsumerState<CreateTicketPage> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final projectController = TextEditingController();
  final assigneeController = TextEditingController();
  final assignedByController = TextEditingController();
  String selectedPriority = 'Low';
  final priorityOptions = ['Low', 'Medium', 'High'];
  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    final baseFontSize = 14.0;
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.dividerColor),
    );

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: Text(
                'Create Ticket',
                style: TextStyle(fontSize: baseFontSize),
              ),
              elevation: 0.5,
            )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(commonRadiusSize),
            ),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(commonPaddingSize * 2),
              child: Form(
                key: formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    FormInput(
                      controller: titleController,
                      hintText: 'Title',
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    sb(0, 2),
                    FormDescription(
                      controller: descriptionController,
                      hintText: 'Description',
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    sb(0, 2),
                    FormInput(
                      controller: projectController,
                      hintText: 'Project Name',
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    sb(0, 2),
                    FormInput(
                      controller: assigneeController,
                      hintText: 'Assignee',
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    sb(0, 2),
                    FormInput(
                      controller: assignedByController,
                      hintText: 'Assigned By',
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    sb(0, 2),
                    GestureDetector(
                      onTap: pickDueDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          border: inputBorder,
                        ),
                        child: Text(
                          dueDate != null
                              ? DateFormat('MMM d, y').format(dueDate!)
                              : 'Select Date',
                          style: TextStyle(fontSize: baseFontSize + 1),
                        ),
                      ),
                    ),
                    sb(0, 2),
                    CustomDropdown(
                      width: 200,
                      options: priorityOptions,
                      value: selectedPriority,
                      fillColor: getPriorityColor(selectedPriority),
                      fontSize: baseFontSize,
                      onChanged: (value) async {
                        if (value != null) {
                          setState(() => selectedPriority = value);
                        }
                      },
                    ),
                    sb(0, 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: pickFiles,
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Attach Files'),
                        ),
                        const SizedBox(height: 12),
                        if (selectedFiles.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(selectedFiles.length, (
                              index,
                            ) {
                              final file = selectedFiles[index];
                              return Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      file.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: baseFontSize,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    tooltip: 'Remove file',
                                    onPressed: () => removeFile(index),
                                  ),
                                ],
                              );
                            }),
                          ),
                      ],
                    ),
                    sb(0, 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        label: 'Create Ticket',
                        type: ButtonType.primary,
                        isSmall: false,
                        onPressed: submitTicket,
                      ),
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

  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => dueDate = picked);
    }
  }

  Future<void> submitTicket() async {
    if (formKey.currentState?.validate() ?? false) {
      // TODO: Handle ticket submission
      await TicketService().createTicket(
        title: titleController.text,
        description: descriptionController.text,
        project: projectController.text,
        assignee: assigneeController.text,
        assignedBy: assignedByController.text,
        dueDate: dueDate,
        attachments: selectedFiles,
        priority: selectedPriority,
      );
      ref.read(ticketNotifierProvider.notifier).loadTickets();
      Navigator.pop(context);
    }
  }

  List<PlatformFile> selectedFiles = [];

  void removeFile(int index) {
    setState(() => selectedFiles.removeAt(index));
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'mp4', 'mov'],
      withData: kIsWeb,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => selectedFiles.addAll(result.files));
    }
  }
}
