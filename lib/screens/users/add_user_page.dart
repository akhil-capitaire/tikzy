import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/models/project_model.dart';
import 'package:tikzy/services/cloudinary_services.dart';
import 'package:tikzy/services/user_services.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/utils/screen_size.dart';
import 'package:tikzy/utils/spaces.dart';
import 'package:tikzy/widgets/buttons.dart';
import 'package:tikzy/widgets/form_input.dart';
import 'package:tikzy/widgets/snackbar.dart';

import '../../providers/project_provider.dart';

class AddUserPage extends ConsumerStatefulWidget {
  const AddUserPage({super.key});

  @override
  ConsumerState<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends ConsumerState<AddUserPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String? selectedRole;
  String? selectedAvatarPath;
  List<ProjectModel> selectedProjects = [];

  final roles = ['User', 'Staff', 'Admin'];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isWeb = screenWidth >= 900;
    final maxWidth = 700.0;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              centerTitle: true,
              title: Text(
                'Add User',
                style: TextStyle(fontSize: baseFontSize + 4),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.width(isMobile ? 4 : 6),
                vertical: ScreenSize.height(4),
              ),
              child: Material(
                elevation: isMobile ? 0 : 8,
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isWeb)
                          Center(
                            child: Text(
                              'Add New User',
                              style: TextStyle(
                                fontSize: baseFontSize + 6,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        sb(0, 4),
                        Center(
                          child: GestureDetector(
                            onTap: openAvatarSelector,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              child: CircleAvatar(
                                radius: 36,
                                backgroundImage: selectedAvatarPath != null
                                    ? AssetImage(selectedAvatarPath!)
                                    : null,
                                child: selectedAvatarPath == null
                                    ? const Icon(Icons.person, size: 36)
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        sb(0, 4),
                        FormInput(
                          controller: nameController,
                          hintText: 'Full Name',
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Enter name'
                              : null,
                          keyboardType: TextInputType.name,
                        ),
                        sb(0, 3),
                        FormInput(
                          controller: emailController,
                          hintText: 'Email',
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Enter email';
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value))
                              return 'Enter valid email';
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        sb(0, 3),
                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          isExpanded: true,
                          style: TextStyle(fontSize: baseFontSize),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 14),
                            labelText: 'Select Role',
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

                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Select role'
                              : null,
                          items: roles
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedRole = value),
                        ),
                        sb(0, 3),
                        if (selectedRole == 'User')
                          Text(
                            'Project Access',
                            style: TextStyle(fontSize: baseFontSize),
                          ),
                        if (selectedRole == 'User') sb(0, 1),
                        if (selectedRole == 'User')
                          InkWell(
                            onTap: openProjectSelector,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: selectedProjects.isEmpty
                                    ? [
                                        Text(
                                          'Select projects',
                                          style: TextStyle(
                                            fontSize: baseFontSize,
                                          ),
                                        ),
                                      ]
                                    : selectedProjects
                                          .map((p) => Chip(label: Text(p.name)))
                                          .toList(),
                              ),
                            ),
                          ),
                        sb(0, 5),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            label: 'Add User',
                            type: ButtonType.primary,
                            isSmall: false,
                            onPressed: submit,
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
      ),
    );
  }

  Future<void> submit() async {
    if (selectedAvatarPath == null) {
      SnackbarHelper.showSnackbar('Please select an avatar', isError: true);
      return;
    }
    if (!(formKey.currentState?.validate() ?? false)) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final role = selectedRole ?? '';

    final avatarFile = await CloudinaryService().loadAssetAsPlatformFile(
      assetPath: selectedAvatarPath ?? 'assets/images/avatars/default.png',
      fileName: 'avatar.png',
    );
    final avatarUrl = await CloudinaryService().uploadFile(avatarFile);

    try {
      await UserService().createUser(
        name: name,
        email: email,
        role: role,
        password: email,
        avatarUrl: avatarUrl,
        projectAccess: selectedProjects,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void openAvatarSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: 7,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (_, index) {
            final path = 'assets/images/avatars/avatar${index + 1}.png';
            return GestureDetector(
              onTap: () {
                setState(() => selectedAvatarPath = path);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(path),
              ),
            );
          },
        ),
      ),
    );
  }

  void openProjectSelector() {
    final projectsAsync = ref.read(projectListProvider);
    if (projectsAsync is! AsyncData) return;
    final allProjects = projectsAsync.value;
    final temp = [...selectedProjects];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Projects',
                style: TextStyle(fontSize: baseFontSize + 2),
              ),
              sb(0, 2),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allProjects!.length,
                  itemBuilder: (_, index) {
                    final project = allProjects![index];
                    final isSelected = temp.any((p) => p.id == project.id);
                    return CheckboxListTile(
                      title: Text(
                        project.name,
                        style: TextStyle(fontSize: baseFontSize),
                      ),
                      value: isSelected,
                      onChanged: (checked) {
                        setSheetState(() {
                          checked!
                              ? temp.add(project)
                              : temp.removeWhere((p) => p.id == project.id);
                        });
                      },
                    );
                  },
                ),
              ),
              sb(0, 2),
              CustomButton(
                isSmall: false,
                type: ButtonType.primary,
                onPressed: () async {
                  setState(() => selectedProjects = temp);
                  Navigator.pop(context);
                },
                label: 'Done',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
