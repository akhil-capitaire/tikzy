import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/providers/ticket_provider.dart';
import 'package:tikzy/utils/fontsizes.dart';

import '../../models/ticket_model.dart';
import '../../utils/screen_size.dart';
import 'ticket_row.dart'; // Your existing TicketRow widget

class TicketsListPage extends ConsumerStatefulWidget {
  const TicketsListPage({super.key});

  @override
  ConsumerState<TicketsListPage> createState() => _TicketsListPageState();
}

class _TicketsListPageState extends ConsumerState<TicketsListPage> {
  List<Ticket> allTickets = [];

  String? selectedProject;
  String? selectedStatus;
  String? selectedAssignee;
  String? selectedPriority;

  List<Ticket> get filteredTickets => allTickets.where((ticket) {
    return (selectedProject == null ||
            selectedProject == 'All' ||
            ticket.projectName == selectedProject) &&
        (selectedStatus == null ||
            selectedStatus == 'All' ||
            ticket.status == selectedStatus) &&
        (selectedAssignee == null ||
            selectedAssignee == 'All' ||
            ticket.assignee == selectedAssignee) &&
        (selectedPriority == null ||
            selectedPriority == 'All' ||
            ticket.priority == selectedPriority);
  }).toList();

  List<String> get allProjects => [
    'All',
    ...{...allTickets.map((t) => t.projectName)},
  ];
  List<String> get allStatuses => [
    'All',
    ...{...allTickets.map((t) => t.status)},
  ];
  List<String> get allAssignees => [
    'All',
    ...{...allTickets.map((t) => t.assignee)},
  ];
  List<String> get allPriority => [
    'All',
    ...{...allTickets.map((t) => t.priority)},
  ];

  void clearFilters() {
    setState(() {
      selectedProject = null;
      selectedStatus = null;
      selectedAssignee = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final tickets = ref.watch(ticketNotifierProvider).value;
    allTickets = tickets ?? [];
    return PopScope(
      onPopInvoked: (context) {
        clearFilters();
        ref.read(ticketNotifierProvider.notifier).loadTickets();
      },
      child: Scaffold(
        appBar: isMobile
            ? AppBar(
                title: Text(
                  'Tickets',
                  style: TextStyle(fontSize: baseFontSize + 4),
                ),
              )
            : null,
        body: Padding(
          padding: EdgeInsets.all(ScreenSize.width(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFilterRow(),
              const SizedBox(height: 16),
              if (!isMobile) buildDesktopHeader(),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredTickets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    final ticket = filteredTickets[index];
                    return TicketRow(ticket: ticket);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,

      children: [
        buildDropdownFilter(
          label: 'Project',
          value: selectedProject,
          options: allProjects,
          placeholder: 'Select project',
          onSelected: (val) => setState(() => selectedProject = val),
        ),
        buildDropdownFilter(
          label: 'Status',
          value: selectedStatus,
          options: allStatuses,
          placeholder: 'Select status',
          onSelected: (val) => setState(() => selectedStatus = val),
        ),
        buildDropdownFilter(
          label: 'Assignee',
          value: selectedAssignee,
          options: allAssignees,
          placeholder: 'Select assignee',
          onSelected: (val) => setState(() => selectedAssignee = val),
        ),
        buildDropdownFilter(
          label: 'Priority',
          value: selectedPriority,
          options: allPriority,
          placeholder: 'Select Priority',
          onSelected: (val) => setState(() => selectedPriority = val),
        ),
      ],
    );
  }

  Widget buildDropdownFilter({
    required String label,
    required String? value,
    required List<String> options,
    required String placeholder,
    required ValueChanged<String?> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 180,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          alignment: Alignment.centerLeft,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              hint: Text(
                placeholder,
                style: const TextStyle(fontSize: 14, color: Colors.black38),
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              onChanged: onSelected,
              items: options
                  .map(
                    (option) => DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDesktopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Title',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Project',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Created',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Due',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Closed',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Assignee',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Assigned By',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: baseFontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
