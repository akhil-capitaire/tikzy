import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tikzy/services/notification_services.dart';
import 'package:tikzy/services/user_services.dart';

import '../models/comment_model.dart';
import '../models/history_model.dart';
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
    final history = {
      'message': 'Ticket created',
      'createdDate': DateTime.now(),
      'updatedBy': '',
      'updatedByName': '',
    };
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
      'history': FieldValue.arrayUnion([history]),
    };

    await firestore.collection(ticketsCollection).add(ticketData);
    SnackbarHelper.showSnackbar("Ticket created successfully");
  }

  fetchAssigneeName(String userId) async {
    final user = await UserService().fetchUserNameById(userId);
    return user ?? 'Unknown User';
  }

  Future<void> updateTicket({
    required String ticketId,
    required String updatedBy,
    Ticket? currentTicket,
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
    final userName = await fetchAssigneeName(updatedBy ?? updatedBy);
    final history = {
      'message':
          (dueDate != null ||
              status != null ||
              priority != null ||
              assignee != null)
          ? '${dueDate != null ? ' Due date changed from ${currentTicket?.dueDate?.toLocal().toString().split(' ')[0]} to ${dueDate.toLocal().toString().split(' ')[0]},' : ''}'
                '${status != null ? 'Status changed from ${currentTicket?.status} to $status,' : ''}'
                '${priority != null ? 'Priority changed from ${currentTicket?.priority} to $priority,' : ''}'
                '${assignee != null ? 'Assignee changed from ${currentTicket?.assignee} to $assignee,' : ''}'
          : 'updated by $userName ',
      'updatedBy': updatedBy,
      'updatedByName': userName,
      'createdDate': DateTime.now().toIso8601String(),
    };
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
      'history': FieldValue.arrayUnion([history]),
    };
    final userlist = await UserService().fetchUsers();
    final filteredUserList = (userlist ?? [])
        .where(
          (element) =>
              element.id == currentTicket!.assignee || element.role == 'Admin',
        )
        .toList();
    for (int i = 0; i < filteredUserList.length; i++) {
      await NotificationService().sendPushyNotification(
        title: '${currentTicket!.id} Ticket is Updated',
        deviceToken: filteredUserList[i].pushyToken.toString(),
        message:
            'The ticket "${currentTicket.title}" has been updated by $userName.',
      );
    }
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
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        projectName: data['project'] ?? '',
        assignee: data['assignee'] ?? '',
        assignedBy: data['assignedBy'] ?? '',
        status: data['status'] ?? 'Open',
        priority: data['priority'] ?? 'Low',
        createdDate: DateTime.tryParse(data['createdAt']),
        dueDate: DateTime.tryParse(data['dueDate']),
        closedDate: (data['closedDate'] as Timestamp?)?.toDate(),
        attachments: List<String>.from(data['attachments'] ?? []),
        comments: (data['comments'] as List<dynamic>?)?.reversed
            .map((e) => Comment.fromMap(e as Map<String, dynamic>))
            .toList(),
        history: (data['history'] as List<dynamic>?)?.reversed
            .map((e) => History.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
    }).toList();
  }

  Future<void> createComment({
    required String ticketId,
    required String commentText,
    required String userId,
    required String authorName,
  }) async {
    final commentData = {
      'comment': commentText,
      'author': userId,
      'authorName': authorName,
      'createdDate': DateTime.now().toIso8601String(),
    };

    await firestore.collection(ticketsCollection).doc(ticketId).update({
      'comments': FieldValue.arrayUnion([commentData]),
    });

    SnackbarHelper.showSnackbar("Comment added successfully");
  }
}
