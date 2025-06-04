import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project_model.dart';
import '../widgets/snackbar.dart';

class ProjectService {
  final FirebaseFirestore _firestore;

  ProjectService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createProject({
    required String name,
    required String description,
  }) async {
    try {
      final docRef = _firestore.collection('projects').doc();
      final model = ProjectModel(
        id: docRef.id,
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );

      await docRef.set(model.toMap());
      SnackbarHelper.showSnackbar("Project created successfully");
    } on FirebaseException catch (e) {
      SnackbarHelper.showSnackbar(
        e.message ?? 'Failed to create project',
        isError: true,
      );
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
      SnackbarHelper.showSnackbar("Project deleted");
    } on FirebaseException catch (e) {
      SnackbarHelper.showSnackbar(
        e.message ?? 'Failed to delete project',
        isError: true,
      );
    }
  }

  Future<List<ProjectModel>> fetchProjects() async {
    final snapshot = await _firestore
        .collection('projects')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return ProjectModel.fromMap(doc.data(), doc.id);
    }).toList();
  }
}
