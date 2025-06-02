import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  final String title;
  final String description;
  final String projectName;
  final String assignee;
  final String assignedBy;
  final String status;
  final String priority; // Default priority
  final DateTime? createdDate;
  final DateTime? dueDate;
  final DateTime? closedDate;
  final List<String> attachments;

  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.projectName,
    required this.assignee,
    required this.assignedBy,
    required this.status,
    required this.priority, // Default priority
    this.createdDate,
    this.dueDate,
    this.closedDate,
    this.attachments = const [],
  });
  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ticket(
      id: doc.id,
      title: data['title'] ?? '', // Avoid null crash
      description: data['description'] ?? '',
      projectName: data['project'] ?? '',
      assignee: data['assignee'] ?? '',
      assignedBy: data['assignedBy'] ?? '',
      priority: data['priority'] ?? 'Low', // Default priority
      status: data['status'] ?? 'Open',
      createdDate: (data['createdAt'] as Timestamp?)?.toDate(),
      dueDate: (data['dueDate'] != null)
          ? DateTime.tryParse(data['dueDate'])
          : null,
      closedDate: (data['closedDate'] != null)
          ? DateTime.tryParse(data['closedDate'])
          : null,
      attachments: List<String>.from(data['attachments'] ?? []),
    );
  }
}
