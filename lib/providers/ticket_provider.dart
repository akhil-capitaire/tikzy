import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/models/user_model.dart';
import 'package:tikzy/utils/shared_preference.dart';

import '../models/ticket_model.dart';
import '../services/ticket_services.dart';

class TicketNotifier extends StateNotifier<AsyncValue<List<Ticket>>> {
  final TicketService _service;

  TicketNotifier(this._service) : super(const AsyncLoading()) {
    loadTickets();
  }

  Future<void> loadTickets() async {
    try {
      final UserModel? user = await SharedPreferenceUtils.getUserModel();
      final tickets = await _service.fetchTickets();

      if (user!.role != 'Admin') {
        final mytickets = tickets
            .where((ticket) => ticket.assignee == user.name)
            .toList();
        state = AsyncData(mytickets);
      } else {
        state = AsyncData(tickets);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  unassignedTickets() async {
    try {
      final tickets = await _service.fetchTickets();
      final unassigned = tickets
          .where((ticket) => ticket.assignee.isEmpty)
          .toList();
      state = AsyncData(unassigned);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => loadTickets();

  Future<void> createTicket({
    required String title,
    required String description,
    required String project,
    required String assignee,
    required String assignedBy,
    DateTime? dueDate,
    required String priority,
    List<PlatformFile> attachments = const [],
  }) async {
    try {
      await _service.createTicket(
        title: title,
        description: description,
        project: project,
        assignee: assignee,
        assignedBy: assignedBy,
        dueDate: dueDate,
        attachments: attachments,
        priority: priority,
      );
      await loadTickets();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateTicket({
    required String ticketId,
    String? title,
    String? description,
    String? status,
    String? project,
    String? assignee,
    String? assignedBy,
    DateTime? dueDate,
    List<PlatformFile> newAttachments = const [],
  }) async {
    try {
      await _service.updateTicket(
        ticketId: ticketId,
        title: title,
        description: description,
        project: project,
        assignee: assignee,
        assignedBy: assignedBy,
        dueDate: dueDate,
        newAttachments: newAttachments,
        status: status,
      );
      await loadTickets();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  int getTicketCountByStatus(String status) {
    final currentState = state;
    if (currentState is AsyncData<List<Ticket>>) {
      return currentState.value
          .where(
            (ticket) => ticket.status.toLowerCase() == status.toLowerCase(),
          )
          .length;
    }
    return 0;
  }

  int getImportanrTicketCount() {
    final currentState = state;
    if (currentState is AsyncData<List<Ticket>>) {
      return currentState.value
          .where((ticket) => ticket.priority.toLowerCase() == 'high')
          .length;
    }
    return 0;
  }

  Future<void> deleteTicket(String ticketId) async {
    try {
      await _service.deleteTicket(ticketId);
      await loadTickets();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final ticketServiceProvider = Provider<TicketService>((ref) {
  return TicketService();
});

final ticketNotifierProvider =
    StateNotifierProvider<TicketNotifier, AsyncValue<List<Ticket>>>((ref) {
      final service = ref.watch(ticketServiceProvider);
      return TicketNotifier(service);
    });
