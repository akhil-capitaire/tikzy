import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String message;
  final DateTime? createdDate;
  final String? updatedBy;
  final String? updatedByName;
  const History({
    required this.message,
    this.createdDate,
    this.updatedBy,
    this.updatedByName,
  });

  factory History.fromMap(Map<String, dynamic> map) {
    final rawDate = map['createdDate'];

    DateTime? parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate);
    }

    return History(
      message: map['message'] ?? '',
      createdDate: parsedDate,
      updatedByName: map['updatedByName'],
      updatedBy: map['updatedBy'],
    );
  }

  /// Optional: to save back to Firestore
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'createdDate': createdDate != null
          ? Timestamp.fromDate(createdDate!)
          : null,
      'updatedBy': updatedBy,
      'updatedByName': updatedByName,
    };
  }
}
