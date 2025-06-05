import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/utils/screen_size.dart';
import 'package:tikzy/utils/spaces.dart';
import 'package:tikzy/widgets/buttons.dart';
import 'package:tikzy/widgets/form_input.dart';

import '../../services/project_services.dart';
import '../../utils/fontsizes.dart';

class AddProjectPage extends ConsumerStatefulWidget {
  const AddProjectPage({super.key});

  @override
  ConsumerState<AddProjectPage> createState() => AddProjectPageState();
}

class AddProjectPageState extends ConsumerState<AddProjectPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final DateTime createdDate = DateTime.now();

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    await ProjectService().createProject(
      name: nameController.text.trim(),
      description: descController.text.trim(),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading =
        ref.watch(buttonLoadingProvider)[ButtonType.primary] ?? false;
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: isMobile
          ? AppBar(
              centerTitle: true,
              title: Text(
                'Add Project',
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
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ScreenSize.width(4)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(commonRadiusSize),
              ),
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(commonPaddingSize),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMobile)
                        Text(
                          "Add Project",
                          style: theme.textTheme.headlineSmall,
                        ),
                      if (!isMobile) sb(0, 3),

                      FormInput(
                        controller: nameController,
                        hintText: 'Enter project name',
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                      ),
                      sb(0, 2),

                      FormDescription(
                        controller: descController,
                        hintText: 'Enter description',
                      ),
                      sb(0, 4),

                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          label: 'Add Project',
                          type: ButtonType.primary,
                          isSmall: false,
                          onPressed: () async {
                            ref
                                .read(buttonLoadingProvider.notifier)
                                .update(
                                  (state) => {
                                    ...state,
                                    ButtonType.primary: true,
                                  },
                                );
                            await submit();
                            ref
                                .read(buttonLoadingProvider.notifier)
                                .update(
                                  (state) => {
                                    ...state,
                                    ButtonType.primary: false,
                                  },
                                );
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
