import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/models/project_model.dart';

import '../services/project_services.dart';

class ProjectNotifier extends StateNotifier<AsyncValue<List<ProjectModel>>> {
  final ProjectService _service;

  ProjectNotifier(this._service) : super(const AsyncLoading()) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      final projects = await _service.fetchProjects();
      state = AsyncData(projects);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => loadProjects();

  Future<void> createProject({
    required String name,
    required String description,
  }) async {
    try {
      await _service.createProject(name: name, description: description);
      await loadProjects();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _service.deleteProject(projectId);
      await loadProjects();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  ProjectModel? getProjectById(String projectId) {
    final currentState = state;
    if (currentState is AsyncData<List<ProjectModel>>) {
      return currentState.value.firstWhere((p) => p.id == projectId);
    }
    return null;
  }
}

final projectServiceProvider = Provider<ProjectService>((ref) {
  return ProjectService();
});

final projectListProvider =
    StateNotifierProvider<ProjectNotifier, AsyncValue<List<ProjectModel>>>((
      ref,
    ) {
      final service = ref.watch(projectServiceProvider);
      return ProjectNotifier(service);
    });
