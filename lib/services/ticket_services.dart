import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import '../models/ticket_model.dart';
import '../widgets/snackbar.dart';
import 'cloudinary_services.dart';

class TicketService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String ticketsCollection = 'tickets';
  final CloudinaryService cloudinaryService = CloudinaryService();

  Future<void> createTicket({
    required String title,
    required String description,
    required String project,
    required String assignee,
    required String assignedBy,
    required String priority,
    DateTime? dueDate,
    List<PlatformFile> attachments = const [],
  }) async {
    final urls = await cloudinaryService.uploadFiles(attachments);

    final ticketData = {
      'title': title,
      'description': description,
      'project': project,
      'assignee': assignee,
      'assignedBy': assignedBy,
      'dueDate': dueDate?.toIso8601String(),
      'attachments': urls,
      'status': 'Open',
      'createdAt': DateTime.now().toIso8601String(),
      'priority': priority,
    };

    await firestore.collection(ticketsCollection).add(ticketData);
    SnackbarHelper.showSnackbar("Ticket created successfully");
  }

  Future<void> updateTicket({
    required String ticketId,
    String? title,
    String? description,
    String? project,
    String? assignee,
    String? assignedBy,
    String? status,
    DateTime? dueDate,
    String? priority,
    List<PlatformFile> newAttachments = const [],
  }) async {
    final urls = await cloudinaryService.uploadFiles(newAttachments);

    final updateData = <String, dynamic>{
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (project != null) 'project': project,
      if (assignee != null) 'assignee': assignee,
      if (assignedBy != null) 'assignedBy': assignedBy,
      if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
      if (urls.isNotEmpty) 'attachments': FieldValue.arrayUnion(urls),
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await firestore
        .collection(ticketsCollection)
        .doc(ticketId)
        .update(updateData);
    SnackbarHelper.showSnackbar("Ticket updated successfully");
  }

  Future<void> deleteTicket(String ticketId) async {
    await firestore.collection(ticketsCollection).doc(ticketId).delete();
  }

  Future<List<Ticket>> fetchTickets() async {
    final querySnapshot = await firestore
        .collection(ticketsCollection)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Ticket(
        description: data['description'],
        id: doc.id,
        title: data['title'] ?? '',
        projectName: data['project'] ?? '',
        assignee: data['assignee'] ?? '',
        assignedBy: data['assignedBy'] ?? '',
        status: data['status'] ?? 'Open',
        createdDate: DateTime.tryParse(data['createdAt']),
        priority: data['priority'] ?? 'Low', // Default priority
        dueDate: data['dueDate'] != null
            ? DateTime.tryParse(data['dueDate'])
            : null,
        closedDate: data['closedDate'] != null
            ? DateTime.tryParse(data['closedDate'])
            : null,
        attachments: List<String>.from(data['attachments'] ?? []),
      );
    }).toList();
  }
}
