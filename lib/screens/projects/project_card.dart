import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/project_model.dart';
import '../../providers/project_provider.dart';
import '../../services/project_services.dart';
import '../../utils/fontsizes.dart';

class ProjectCard extends ConsumerWidget {
  final ProjectModel project;

  const ProjectCard({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          project.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: baseFontSize + 1,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.description,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: baseFontSize,
              ),
            ),
            Text(
              'Created: ${project.createdAt.toLocal().toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: baseFontSize - 1,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
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
                      ref.read(projectListProvider.notifier).loadProjects();
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
        ),
        onTap: () {
          // TODO: navigate to project detail/edit page
        },
      ),
    );
  }
}
