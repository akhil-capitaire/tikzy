import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'open':
      return Colors.blue;
    case 'in progress':
      return Colors.orange;
    case 'closed':
      return Colors.green;
    case 'important':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
