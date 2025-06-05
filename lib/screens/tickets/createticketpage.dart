import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tikzy/models/project_model.dart';
import 'package:tikzy/models/user_model.dart';
import 'package:tikzy/providers/user_provider.dart';
import 'package:tikzy/services/project_services.dart';
import 'package:tikzy/services/ticket_services.dart';
import 'package:tikzy/services/user_services.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/utils/shared_preference.dart';
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
  List<String> userList = [];
  List<ProjectModel> projectList = [];
  String selectedUser = '';
  String selectedProject = '';
  DateTime? dueDate;
  UserModel? userdata = UserModel(id: '', name: '', email: '', role: '');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdata();
  }

  void fetchdata() async {
    final users = await UserService().fetchAllUsernames();
    final projects = await ProjectService().fetchProjects();
    userdata = await SharedPreferenceUtils.getUserModel();
    setState(() {
      userList = users;
      projectList = projects;
      selectedUser = users.isNotEmpty ? users.first : '';
      selectedProject = projects.isNotEmpty ? projects.first.name : '';
      print(userdata!.projectAccess);
    });
  }

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

                    if (userdata!.role == "Admin") sb(0, 2),
                    if (userdata!.role == "Admin")
                      Text(
                        'Assignee',
                        style: TextStyle(fontSize: baseFontSize),
                      ),
                    if (userdata!.role == "Admin")
                      CustomDropdown(
                        width: 200,
                        options: userList,
                        value: selectedUser,
                        fontSize: baseFontSize,
                        onChanged: (value) {
                          if (value != null && value != selectedUser) {
                            setState(() {
                              selectedUser = value;
                              assigneeController.text = value;
                            });
                          }
                        },
                      ),
                    sb(0, 2),
                    if (userdata != null)
                      Text(
                        'Project Name',
                        style: TextStyle(fontSize: baseFontSize),
                      ),
                    if (userdata!.role == 'Admin' || userdata!.role == 'Staff')
                      CustomDropdown(
                        width: 200,
                        options: projectList
                            .map((project) => project.name)
                            .toList(),
                        value: selectedProject,
                        fontSize: baseFontSize,
                        onChanged: (value) {
                          if (value != null && value != selectedProject) {
                            setState(() {
                              selectedProject = value;
                            });
                          }
                        },
                      ),
                    if (userdata!.role == 'User')
                      CustomDropdown(
                        width: 200,
                        options: userdata!.projectAccess
                            .map((project) => project.name)
                            .toList(),
                        value: selectedProject,
                        fontSize: baseFontSize,
                        onChanged: (value) {
                          if (value != null && value != selectedProject) {
                            setState(() {
                              selectedProject = value;
                            });
                          }
                        },
                      ),
                    sb(0, 2),

                    GestureDetector(
                      onTap: pickDueDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 14),
                          labelText: 'Due Date',
                          counterText: '',

                          hintStyle: TextStyle(
                            fontSize: baseFontSize,
                            fontWeight: FontWeight.w400,
                          ),
                          labelStyle: TextStyle(
                            fontSize: baseFontSize,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
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
                    Text('Priority', style: TextStyle(fontSize: baseFontSize)),
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
    final user = ref.read(userLocalProvider);
    if (formKey.currentState?.validate() ?? false) {
      // TODO: Handle ticket submission
      await ref
          .read(buttonLoadingProvider.notifier)
          .update((state) => {...state, ButtonType.primary: true});
      await TicketService().createTicket(
        title: titleController.text,
        description: descriptionController.text,
        project: selectedProject,
        assignee: assigneeController.text,
        assignedBy: user!.id.toString(),
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
