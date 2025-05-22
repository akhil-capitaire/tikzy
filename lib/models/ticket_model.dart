class Ticket {
  final String id;
  final String title;
  final String projectName;
  final DateTime createdDate;
  final DateTime? dueDate;
  final DateTime? closedDate;
  final String assignee;
  final String assignedBy;
  final String status;

  Ticket({
    required this.id,
    required this.title,
    required this.projectName,
    required this.createdDate,
    this.dueDate,
    this.closedDate,
    required this.assignee,
    required this.assignedBy,
    required this.status,
  });
}
