import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/project_model.dart';
import '../../providers/project_provider.dart';
import '../../services/project_services.dart';
import '../../utils/fontsizes.dart';

class ProjectTableRow extends ConsumerWidget {
  final ProjectModel project;

  const ProjectTableRow({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      hoverColor: Colors.grey.shade100,
      onTap: () {
        // TODO: navigate to project detail/edit page
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                project.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: baseFontSize,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                project.description,
                style: TextStyle(fontSize: baseFontSize),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                project.createdAt.toLocal().toString().split(' ')[0],
                style: TextStyle(fontSize: baseFontSize),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Project'),
                      content: Text(
                        'Are you sure you want to delete this project?',
                        style: TextStyle(fontSize: baseFontSize),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await ProjectService().deleteProject(project.id);
                            ref
                                .read(projectListProvider.notifier)
                                .loadProjects();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
