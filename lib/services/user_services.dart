import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/project_model.dart';
import '../models/user_model.dart';
import '../widgets/snackbar.dart';

class UserService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetch all usernames as a list of strings.
  Future<List<String>> fetchAllUsernames() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  /// Fetch all users as a list of UserModel.
  Future<List<UserModel>> fetchUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String role,
    required String password,
    String? avatarUrl,
    required List<ProjectModel> projectAccess,
  }) async {
    try {
      // 1. Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Create user document
      final docRef = _firestore.collection('users').doc();

      await docRef.set({
        'id': docRef.id,
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'avatarUrl': avatarUrl ?? '',
        'projectAccess': projectAccess.map((p) => p.toMap()).toList(),
      });

      SnackbarHelper.showSnackbar("User created successfully");
    } on FirebaseAuthException catch (e) {
      SnackbarHelper.showSnackbar("${e.message}", isError: true);
    } on FirebaseException catch (e) {
      SnackbarHelper.showSnackbar("${e.message}", isError: true);
    }
  }
}
