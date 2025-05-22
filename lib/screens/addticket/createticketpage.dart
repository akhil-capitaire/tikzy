import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/utils/spaces.dart';
import 'package:tikzy/widgets/buttons.dart';
import 'package:tikzy/widgets/form_input.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController projectController = TextEditingController();
  final TextEditingController assigneeController = TextEditingController();
  final TextEditingController assignedByController = TextEditingController();

  String status = 'Open';
  DateTime? dueDate;
  final List<String> statusOptions = [
    'Open',
    'In Progress',
    'Closed',
    'On Hold',
  ];

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

  submitTicket() async {
    if (formKey.currentState?.validate() ?? false) {
      // Submit ticket logic
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseFontSize = 14.0;
    final spacing = const SizedBox(height: 20);
    final theme = Theme.of(context);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.dividerColor),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Ticket', style: TextStyle(fontSize: baseFontSize)),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormInput(
                        controller: titleController,
                        hintText: 'Title',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      spacing,
                      FormDescription(
                        controller: descriptionController,
                        hintText: 'Description',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      spacing,
                      FormInput(
                        controller: projectController,
                        hintText: 'Project Name',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      spacing,
                      FormInput(
                        controller: assigneeController,
                        hintText: 'Assignee',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),

                      spacing,
                      FormInput(
                        controller: assignedByController,
                        hintText: 'Assigned By',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      spacing,
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
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
                          ),
                          // const SizedBox(width: 16),
                          // Expanded(
                          //   child: CustomDropdown(
                          //     options: statusOptions,
                          //     value: status,
                          //     onChanged: (val) =>
                          //         setState(() => status = val ?? 'Open'),
                          //   ),
                          // ),
                        ],
                      ),
                      sb(0, 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomButton(
                          label: 'Create Ticket',
                          type: ButtonType.primary,
                          isSmall: false,
                          onPressed: () async {
                            submitTicket();
                          },
                        ),
                      ),
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
}
