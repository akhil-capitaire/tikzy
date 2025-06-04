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

  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// NEW: toJson alias for clarity and consistency
  Map<String, dynamic> toJson() => toMap();
}
