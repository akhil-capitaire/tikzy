import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tikzy/utils/shared_preference.dart';

import '../models/project_model.dart';
import '../models/user_model.dart';
import '../widgets/snackbar.dart';
import 'notification_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Stream to observe auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns current Firebase user, or null if not signed in.
  User? get currentUser => _auth.currentUser;

  /// Sign in using email and password.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (!kIsWeb && Platform.isAndroid) await NotificationService().init();
      SnackbarHelper.showSnackbar("Logged in successfully");
      if (credential.user != null) {
        final query = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          final userData = query.docs.first;
          final user = UserModel(
            id: userData.id,
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            role: userData['role'] ?? 'user',
            createdAt: userData['createdAt'],
            avatarUrl: userData.data().containsKey('avatarUrl')
                ? userData['avatarUrl']
                : '',
            pushyToken: userData.data().containsKey('pushyToken')
                ? userData['pushyToken']
                : '',
            updatedAt: userData.data().containsKey('updatedAt')
                ? userData['updatedAt']
                : Timestamp.now(),
            projectAccess:
                (userData['projectAccess'] as List<dynamic>?)
                    ?.map(
                      (e) =>
                          ProjectModel.fromJson(Map<String, dynamic>.from(e)),
                    )
                    .toList() ??
                [],
          );
          SharedPreferenceUtils.saveUserModel(user);
        }
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code, message: e.message ?? 'Unknown error');
    }
  }

  /// Register a new user with email and password.
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code, message: e.message ?? 'Unknown error');
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
    SnackbarHelper.showSnackbar("Logged out successfully");
  }

  /// Send a password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        SnackbarHelper.showSnackbar("Email not found", isError: true);
        throw AuthException(code: "user-not-found", message: "Email not found");
      }

      await _auth.sendPasswordResetEmail(email: email.trim());
      SnackbarHelper.showSnackbar("Reset email sent successfully");
    } on FirebaseAuthException catch (e) {
      SnackbarHelper.showSnackbar("Error: ${e.message}", isError: true);
      throw AuthException(code: e.code, message: e.message ?? 'Unknown error');
    }
  }
}

/// Custom exception for UI or domain-layer handling.
class AuthException implements Exception {
  final String code;
  final String message;

  AuthException({required this.code, required this.message});

  @override
  String toString() => 'AuthException($code): $message';
}
