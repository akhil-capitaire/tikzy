import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tikzy/models/comment_model.dart';
import 'package:tikzy/models/history_model.dart';

class Ticket {
  final String id;
  final String title;
  final String description;
  final String projectName;
  final String assignee;
  final String assignedBy;
  final String status;
  final String priority;
  final DateTime? createdDate;
  final DateTime? dueDate;
  final DateTime? closedDate;
  final List<String> attachments;
  final List<Comment>? comments;
  final List<History>? history;

  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.projectName,
    required this.assignee,
    required this.assignedBy,
    required this.status,
    required this.priority,
    this.createdDate,
    this.dueDate,
    this.closedDate,
    this.attachments = const [],
    this.comments,
    this.history,
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
      comments: (data['comments'] != null)
          ? List<Comment>.from(data['comments'].reversed)
          : [],
      history: (data['history'] != null)
          ? List<History>.from(data['history'].reversed)
          : [],
    );
  }
}
