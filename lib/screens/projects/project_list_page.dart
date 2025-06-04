import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/providers/project_provider.dart';
import 'package:tikzy/screens/projects/project_card.dart';
import 'package:tikzy/screens/projects/project_row.dart';
import 'package:tikzy/utils/fontsizes.dart';

import '../../models/project_model.dart';

class ProjectListPage extends ConsumerWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectListProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: Text(
                'Projects',
                style: TextStyle(fontSize: baseFontSize + 4),
              ),
            )
          : null,
      body: projectAsync.when(
        data: (projects) => ProjectListBody(projects: projects),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class ProjectListBody extends StatefulWidget {
  final List<ProjectModel> projects;

  ProjectListBody({super.key, required this.projects});

  @override
  State<ProjectListBody> createState() => _ProjectListBodyState();
}

class _ProjectListBodyState extends State<ProjectListBody> {
  @override
  String _search = '';

  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final filtered = widget.projects
        .where(
          (u) =>
              u.name.toLowerCase().contains(_search.toLowerCase()) ||
              u.name.toLowerCase().contains(_search.toLowerCase()),
        )
        .toList();

    if (widget.projects.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 12,
              ),
            ),
            onChanged: (val) => setState(() => _search = val),
          ),
        ),
        if (isDesktop) const ProjectTableHeader(),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No users match your search.'))
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final project = filtered[index];
                    return isDesktop
                        ? ProjectTableRow(project: project)
                        : ProjectCard(project: project);
                  },
                ),
        ),
      ],
    );
  }
}

class ProjectTableHeader extends StatelessWidget {
  const ProjectTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: baseFontSize + 2,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Descrption',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: baseFontSize + 2,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Created date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: baseFontSize + 2,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: baseFontSize + 2,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
