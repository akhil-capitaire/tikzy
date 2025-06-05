import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  /// Factory for Firestore document snapshots or maps
  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      createdAt: _parseDate(map['createdAt']),
    );
  }

  /// Factory for JSON decoding (e.g. SharedPreferences/local)
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: _parseDate(json['createdAt']),
    );
  }

  /// Serialize for Firestore or SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// For SharedPreferences or network storage
  Map<String, dynamic> toJson() => toMap();

  /// Handles both Timestamp and ISO8601 strings
  static DateTime _parseDate(dynamic source) {
    if (source is Timestamp) {
      return source.toDate();
    } else if (source is String) {
      return DateTime.tryParse(source) ?? DateTime.now();
    } else if (source is int) {
      // Optional fallback if stored as millis
      return DateTime.fromMillisecondsSinceEpoch(source);
    }
    return DateTime.now();
  }
}
