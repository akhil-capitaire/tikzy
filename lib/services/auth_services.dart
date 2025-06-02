import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/snackbar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      SnackbarHelper.showSnackbar("Logged in successfully");
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
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
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
