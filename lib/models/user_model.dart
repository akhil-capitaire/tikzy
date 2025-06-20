import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tikzy/models/project_model.dart';

/// Represents an application user.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? pushyToken;
  final String? avatarUrl;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final List<ProjectModel> projectAccess;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.pushyToken,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
    this.projectAccess = const [],
  });

  /// Creates a [UserModel] from Firestore document snapshot.
  factory UserModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      id: doc.id,
      name: data['name'] as String,
      email: data['email'] as String,
      role: data['role'] as String,
      avatarUrl: data['avatarUrl'] as String?,
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
      pushyToken: data['pushyToken'] as String?,
      projectAccess:
          (data['projectAccess'] as List<dynamic>?)
              ?.map((e) => ProjectModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }

  /// Creates a [UserModel] from a plain JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      pushyToken: json['pushyToken'] as String?,
      createdAt: json['createdAt'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      updatedAt: json['updatedAt'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
      projectAccess:
          (json['projectAccess'] as List<dynamic>?)
              ?.map((e) => ProjectModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }

  /// Converts this user to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'pushyToken': pushyToken,
      'projectAccess': projectAccess.map((p) => p.toJson()).toList(),
    };
  }

  /// Firestore map (excluding `id`, which is stored in doc ID).
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'pushyToken': pushyToken,
      'projectAccess': projectAccess.map((p) => p.toJson()).toList(),
    };
  }

  /// Returns a copy with updated fields.
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? pushyToken,
    String? avatarUrl,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    List<ProjectModel>? projectAccess,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      pushyToken: pushyToken ?? this.pushyToken,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      projectAccess: projectAccess ?? this.projectAccess,
    );
  }
}
